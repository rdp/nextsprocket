class Feedback
  include MongoMapper::Document

  key :name, String, :required => true
  key :email, String, :required => true
  key :title, String, :required => true
  key :message, String, :required => true
  
  after_create :email_ns_team
  
  private
  
  def email_ns_team
    UserNotifier.deliver_new_feedback(self)
  end
end
