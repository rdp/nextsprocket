class ActivityItem
  include MongoMapper::Document
  
  # nitin shantharam created a new task "fix this bug" in bug fix.
  # nitin shantharam accepted mark's solution for the task "fix this bug."
  # the task "fix this bug" has an open source solution is now completed.
  # nitin shantharam contributed $10 to the reward for the task "fix this bug."
  # nitin shantharam increased the reward for the task "fix this task" to $15.
  # nitin shantharam commented on the task "fix this bug."
  # nitin shantharam commented on mark's solution for the task "fix this bug."
  # nitin shantharam submitted a solution to the task "fix this bug"
  
  key :profile_id, ObjectId
  key :task_id, ObjectId
  key :task_submission_id, ObjectId
  key :task_comment_id, ObjectId
  key :task_reward_id, ObjectId
  key :task_submission_comment_id, ObjectId
  
  key :type, String, :required => true
  timestamps!
  
  belongs_to :profile
  belongs_to :task
  belongs_to :task_submission
  belongs_to :task_comment
  belongs_to :task_submission_comment
  belongs_to :task_reward
  
  def self.types
    Constants::ActivityItemType
  end
  
  def self.create_task_created_event(profile, task)
    ActivityItem.create(
      :type => self.types::TASK_CREATED,
      :profile_id => profile.id,
      :task_id => task.id
    )
  end
  
  def self.create_task_submission_accepted_event(profile, task_submission)
    ActivityItem.create(
      :type => self.types::TASK_SUBMISSION_ACCEPTED,
      :profile_id => profile.id,
      :task_id => task_submission.task_id,
      :task_submission_id => task_submission.id
    )
  end
  
  def self.create_task_completed_event(profile, task)
    ActivityItem.create(
      :type => self.types::TASK_COMPLETED,
      :profile_id => profile.id,
      :task_id => task.id
    )
  end
  
  def self.create_new_contribution_event(profile, task_reward)
    ActivityItem.create(
      :type => self.types::NEW_CONTRIBUTION,
      :profile_id => profile.id,
      :task_id => task_reward.task_id,
      :task_reward_id => task_reward.id
    )
  end
  
  def self.create_creator_reward_increased_event(profile, task_reward)
    ActivityItem.create(
      :type => self.types::CREATOR_REWARD_INCREASED,
      :profile_id => profile.id,
      :task_id => task_reward.task_id,
      :task_reward_id => task_reward.id
    )
  end
  
  def self.create_new_task_comment_event(profile, task_comment, task)
    ActivityItem.create(
      :type => self.types::NEW_TASK_COMMENT,
      :profile_id => profile.id,
      :task_id => task.id
    )
  end
  
  def self.create_new_task_submission_comment_event(profile, task_submission_comment, task_submission)
    ActivityItem.create(
      :type => self.types::NEW_TASK_SUBMISSION_COMMENT,
      :profile_id => profile.id,
      :task_id => task_submission.task_id,
      :task_submission_id => task_submission.id
    )
  end
  
  def self.create_new_task_submission_event(profile, task_submission)
    ActivityItem.create(
      :type => self.types::NEW_TASK_SUBMISSION,
      :profile_id => profile.id,
      :task_id => task_submission.task_id,
      :task_submission_id => task_submission.id
    )
  end
  
  def self.create_new_user_event(profile)
    ActivityItem.create(
      :type => self.types::NEW_USER,
      :profile_id => profile.id
    )
  end
end
