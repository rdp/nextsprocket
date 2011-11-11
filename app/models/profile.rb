class Profile
  include MongoMapper::Document
  include SimplesIdeias::Acts::Permalink
  has_permalink :name, :unique => true, :to_param => :permalink

  after_create :create_reputation
  key :user_id, Integer, :required => true
  key :name, String, :required => true
  key :twitter_username, String
  key :website, String
  key :about_me, String
  key :permalink, String, :required => true

  key :reputation_points, Integer, :default => 0
  key :completed_tasks_count, Integer, :default => 0
  key :accepted_tasks_count, Integer, :default => 0
  
  validates_length_of :about_me, :within => 0..300
  
  has_many :tasks, :dependent => :destroy
  has_many :task_submissions, :dependent => :destroy
  has_many :task_rewards, :dependent => :destroy
  has_many :sent_payments, :foregin_key => "sender_id", :class_name =>"Payment"
  has_many :received_payments, :foregin_key => "recipient_id", :class_name =>"Payment"
  has_many :preapproval_payments, :foregin_key => "sender_id", :class_name =>"PreapprovalPayment", :dependent => :destroy
  
  timestamps!
  
  def email
    User.find(self[:user_id]).email
  end

  #mapping to AR user
  def user
    User.find(self[:user_id])
  end

  #mapping to AR user
  def user=(user)
    self.update_attributes(:user_id => user.id)
  end

  def reputation
    #using has_one association gave a stack too deep error...
    Reputation.first(:profile_id => self.id)
  end
  
  def create_reputation
    Reputation.create(:profile_id => self.id)
  end
  
  def before_destroy
    reputation.destroy
  end
end
