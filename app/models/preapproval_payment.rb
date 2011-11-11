class PreapprovalPayment
  include MongoMapper::Document
  before_validation_on_create :set_commission_amount

  key :sender_id, ObjectId, :required => true
  key :amount, Float, :required => true, :numeric => true
  key :commission_amount, Float, :required => true
  key :currency, String, :required => true, :default => 'USD'

  key :task_id, ObjectId, :required => true
  #paypal specific keys
  key :preapproval_key, String
  key :sender_email, String
  
  belongs_to :sender, :class_name => 'Profile'
  belongs_to :task

  timestamps!

  def preapprove_payment
    total_amount = self[:amount] + self[:commission_amount]
    start_date = Time.now.xmlschema
    end_date = task.deadline_date.to_time.xmlschema

    data = {"returnUrl" =>"http://#{Constants::SITE_HOST}/preapproval_payments/#{self.id}/completed_paypal",
            "requestEnvelope"=>{"errorLanguage"=>"en_US"},
            "currencyCode"=>self[:currency],
            "cancelUrl" =>"http://#{Constants::SITE_HOST}/preapproval_payments/#{self.id}/canceled_paypal",
            "ipnNotificationUrl" => "http://#{Constants::SITE_HOST}/paypal_ipn",
            "maxTotalAmountOfAllPayments" => total_amount.to_s,
            "maxNumberOfPayments" => "1",
            "startingDate" => start_date,
            "endingDate" => end_date
            }
    preapproval_request = PaypalAdaptive::Request.new
    preapproval_response = preapproval_request.preapproval(data)

    if preapproval_response.success?
      self[:preapproval_key] = preapproval_response['preapprovalKey']
      self.save

      return preapproval_response.preapproval_paypal_payment_url
    else
      return nil
    end
  end

  def set_commission_amount
    self[:commission_amount] = Payment.calc_commission(self[:amount]) if self[:amount]
  end

  def complete_from_paypal!
    set_sender_email!
    tr = TaskReward.first({:task_id => self[:task_id],
                                            :profile_id => self[:sender_id]})
    tr.update_attributes({:preapproval => true}) if tr

  end

  def set_sender_email!
    self[:sender_email] = PreapprovalPayment.get_email_address_from_paypal(self[:preapproval_key])
    self.save
  end

  def self.get_email_address_from_paypal(temp_preapproval_key)
    data = {"preapprovalKey" => temp_preapproval_key, "requestEnvelope"=>{"errorLanguage"=>"en_US"}}
    request = PaypalAdaptive::Request.new
    response = request.preapproval_details(data)
    response['senderEmail']
  end
end
