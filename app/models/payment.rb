require 'active_support/secure_random'

class Payment
  include MongoMapper::Document

  before_validation_on_create :set_commission_amount
  validate :validate_correct_payment_amount

  key :sender_id, ObjectId, :required => true
  key :recipient_id, ObjectId, :required => true
  key :task_submission_id, ObjectId, :required => true
  key :amount, Float, :required => true
  key :commission_amount, Float, :required => true
  key :currency, String, :required => true, :default => 'USD'
  key :paid, Boolean, :required =>true, :default => false

  #paypal specific keys
  key :paypal_pay_key, String
  key :paypal_payment_status, String
  key :preapproval_key, String
  key :sender_email, String  #only used with preapproval pay
  
  belongs_to :sender, :class_name => 'Profile'
  belongs_to :recipient, :class_name => 'Profile'
  belongs_to :task_submission

  timestamps!
  
  def pay
    return_url = "http://#{Constants::SITE_HOST}/payments/#{self.id}/completed_paypal"

    data = {"returnUrl" => return_url,
            "requestEnvelope"=>{"errorLanguage"=>"en_US"},
            "currencyCode"=>self[:currency],
            "cancelUrl" =>"http://#{Constants::SITE_HOST}/payments/#{self.id}/canceled_paypal",
            "actionType" => "PAY",
            "ipnNotificationUrl" => "http://#{Constants::SITE_HOST}/paypal_ipn"}

    if self[:preapproval_key]
      data["preapprovalKey"] = self[:preapproval_key]
      data["senderEmail"] = self[:sender_email]
    end
    
    #paypal sandbox needs registered emails to test
    recipient_email = Rails.env == 'production' ? recipient.email : "prgrmr_1262035936_per@nextsprocket.com"

    data["receiverList"]= {"receiver"=>
            [{"email"=> recipient_email, "amount"=> self[:amount].to_s },
            {"email" => COMMISSION_EMAIL, "amount" => self[:commission_amount].to_s }]}
            
    pay_request = PaypalAdaptive::Request.new
    @pay_response = pay_request.pay(data)

    if @pay_response.success?
      self[:paypal_pay_key] = @pay_response['payKey']
      self.save
      if self[:preapproval_key]
        return return_url
      else
        return @pay_response.approve_paypal_payment_url
      end
    else
      return nil
    end
  end

  def details
    return nil if self[:paypal_pay_key].blank?

    data = {"requestEnvelope"=>{"errorLanguage"=>"en_US"}, "payKey" => self[:paypal_pay_key]}
    details_request = PaypalAdaptive::Request.new
    payment_details_response = details_request.payment_details(data)
    payment_details_response['status']
  end

  def paypal_errors
    @pay_response ?  @pay_response.error_message : ""
  end

  def set_commission_amount
    self[:commission_amount] = Payment.calc_commission(self[:amount])
  end

  def self.calc_commission(money)
    (money * COMMISSION_PERCENTAGE).round(2)
  end

  def generate_complete_code
    ActiveSupport::SecureRandom.hex(16)
  end

  def confirm_payment!
    return true if self[:paid]
    status = payment_status_from_paypal
    self.update_attributes(:paypal_payment_status => status)

    if status == 'COMPLETED'
      Reputation.paid_for_submission(self)

      ts = self.task_submission
      task = ts.task

      #only mark it paid when the task creator pays
      if self[:sender_id] == task.profile.id
        ts.paid! unless ts.paid?
        task.complete! unless task.completed?
      end

      reward = TaskReward.first({:task_id => task.id, :profile_id => self[:sender_id]})
      reward.paid!

      self.update_attributes(:paid => true)
      return true
    end

    false
  end

  def payment_status_from_paypal
    return nil unless self[:paypal_pay_key]
    data = {"payKey" => self[:paypal_pay_key], "requestEnvelope"=>{"errorLanguage"=>"en_US"}}
    request = PaypalAdaptive::Request.new
    response = request.payment_details(data)
    response['status']
  end

  def validate_correct_payment_amount
    if self.amount.nil? || self.amount.to_f <= 0
      errors.add(:amount, "must be a valid number.")
      return
    end

    promised_rewards = self.task_submission.task.rewards
    matching_reward = promised_rewards.select{|reward| reward.profile_id == self.sender_id}.first
    
    if matching_reward && self.amount < matching_reward.starting_amount
      errors.add(:amount, 'must be the same or greater than the original specified amount.')
    end

  end
end
