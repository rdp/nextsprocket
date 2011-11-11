class TaskReward
  include MongoMapper::Document
  before_validation_on_create :set_starting_amount
  after_save :set_task_total_reward
  after_create :create_activity_item
  
  validate :not_less_than_starting_amount
  validate :not_preapproval
  validate :task_not_expired

  key :profile_id, ObjectId, :required => true
  key :task_id, ObjectId, :required => true
  key :starting_amount, Float, :required => true
  key :amount, Float, :required => true
  key :preapproval, Boolean, :default => false
  key :status, String, :default => Constants::TaskRewardStatus::UNPAID, :required => true
  
  timestamps!
  
  belongs_to :profile
  belongs_to :task

  def set_starting_amount
    self[:starting_amount] = self[:amount]
  end

  def not_less_than_starting_amount
    if self[:amount] < self[:starting_amount]
      errors.add(:total_reward, "can't be less than the starting amount.")
    end
  end

  def task_not_expired
    if self.task && self.task.expired?
      errors.add(:task, "has already expired.")
    end
  end

  def not_preapproval
    if self[:preapproval] && self[:amount] != self[:starting_amount]
      errors.add(:amount, "can't be changed because it is a preapproval payment.")
    end
  end

  def set_task_total_reward
    task.add_to_reward!(self.amount)
  end
  
  def paid!
    self.status = Constants::TaskRewardStatus::PAID
    self.save(:validate => false)
  end
  
  def paid?
    self.status == Constants::TaskRewardStatus::PAID
  end

  def self.user_contributed_amount(task, user)
   t = TaskReward.first({:task_id => task.id, :profile_id => user.profile_id})
   t.amount
  end
  
  def is_user_owner?(user)
    return false unless user
    self.profile_id.to_s == user.profile_id.to_s
  end
  
  private
  
  def create_activity_item
    ActivityItem.create_new_contribution_event(profile, self)
  end
end