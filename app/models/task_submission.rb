class TaskSubmission
  include MongoMapper::Document
  include TasksHelper

  validate_on_create :validate_not_task_owner
  after_create :email_task_creator
  after_create :sync_count_for_task
  before_destroy :sync_count_for_task
  after_create :create_activity_item
  
  key :profile_id, ObjectId, :required => true
  key :task_id, ObjectId, :required => true
  key :solution_format, String, :required => true
  key :link, String, :required => false
  key :file, String, :required => false
  key :status, String, :default => Constants::TaskSubmissionStatus::UNREAD, :required =>true
  key :open_at, Time
  key :ignored_once, Boolean, :default => false #set when task creator's reputation points are adjusted when task is open but ignored task submission
  timestamps!

  has_many :comments, :class_name => 'TaskSubmissionComment'
  belongs_to :profile
  belongs_to :task
  has_many :payments

  #mount_uploader :file, SubmissionUploader

  def validate_not_task_owner
    if task.profile.id == profile.id
      errors.add(:user, "cannot be the same as the task creator.")
    end
  end

  def self.adjust_reputation_for_opened_and_ignored!
    ignored_task_submissions = TaskSubmission.all(:conditions => {:ignored_once  => false,
                                          :status => Constants::TaskSubmissionStatus::OPEN },
                    :limit => 100)

    ignored_task_submissions.each(&:opened_but_ignored!)
  end

  def is_user_owner?(user)
    return false unless user
    self[:profile_id].to_s == user.profile_id.to_s
  end

  def unread?
    self[:status] == Constants::TaskSubmissionStatus::UNREAD
  end
  
  def opened?
    self[:status] == Constants::TaskSubmissionStatus::OPEN
  end

  def accepted?
    self[:status] == Constants::TaskSubmissionStatus::ACCEPTED
  end
  
  def rejected?
    self[:status] == Constants::TaskSubmissionStatus::REJECTED
  end

  def paid?
    self[:status] == Constants::TaskSubmissionStatus::PAID
  end

  def ignored_once_by_task_creator?
      self[:ignored_once].nil? || self[:ignored_once] == true
  end
  #update reputation points from here
  def open!
    self.update_attributes!({:status => Constants::TaskSubmissionStatus::OPEN, :open_at => Time.now})
  end

  def accept!
    self.update_attributes!({:status => Constants::TaskSubmissionStatus::ACCEPTED})
    Reputation.task_submission_accepted(self)
    ActivityItem.create_task_submission_accepted_event(profile, self)
  end

  def reject!
    self.update_attributes!({:status => Constants::TaskSubmissionStatus::REJECTED})
    
    Reputation.rejected_submission_without_reason(self) if comments.size == 0
  end

  def paid!
    self.update_attributes!({:status => Constants::TaskSubmissionStatus::PAID})
  end

  def opened_but_ignored!
    if self.opened? && more_than_2_weeks_from(self[:open_at])
      Reputation.opened_and_ignored_submission(self) 
    end
  end

  def email_task_creator
    UserNotifier.deliver_new_task_submission(self)
  end

  def sync_count_for_task
    self.task.sync_submissions_count!
  end
  
  def create_activity_item
    ActivityItem.create_new_task_submission_event(profile, self)
  end
end