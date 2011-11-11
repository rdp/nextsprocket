class TaskComment
  include MongoMapper::EmbeddedDocument

  key :profile_id, ObjectId, :required => true
  key :content, String
  key :created_at, Time

  belongs_to :profile
  belongs_to :task

end
