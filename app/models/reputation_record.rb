class ReputationRecord
  include MongoMapper::EmbeddedDocument

  key :action_code, Integer  #refer to Constants::ReputationActionCode
  key :task_id, ObjectId
  key :task_submission_id, ObjectId
  key :recipient_profile_id, ObjectId

  belongs_to :reputation
  belongs_to :task
  belongs_to :task_submission
  
end
