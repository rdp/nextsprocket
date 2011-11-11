class Task
  include MongoMapper::Document
  include SimplesIdeias::Acts::Permalink

  has_permalink :title, :unique => true, :to_param => :permalink

  validate_on_create :validate_initial_amount
  validate :validate_deadline
  before_save :format_tags
  before_save :normalize_deadline
  after_create :create_activity_item
  after_create :create_first_reward
  after_create :email_creator

  validates_uniqueness_of :title

  key :title, String, :required => true, :length => (5..60)
  key :permalink, String, :required => true
  key :profile_id, ObjectId, :required => true

  key :description, String, :required => true, :length => (1..400)   
  key :category, String, :required =>true
  key :associated_project_name, String
  key :computer_language, String
  key :solution_format, String, :required =>true
  key :solution_license, String, :required => true
  
  key :total_reward, Float

  key :deadline_date, Time, :required =>true
  key :status, String, :default => Constants::TaskStatus::OPEN, :required =>true
  key :featured_rating, Integer, :default => 0
  
  key :requirements, String
  
  key :tags, Array
  key :submissions_count, Integer, :default => 0
  
  key :users_ids_working_on_this, Array
  
  timestamps!
  
  belongs_to :profile
  has_many :submissions, :class_name => 'TaskSubmission', :dependent => :destroy, :order => 'created_at desc'
  has_many :comments, :class_name => 'TaskComment', :dependent => :destroy
  has_many :rewards, :class_name => 'TaskReward', :dependent => :destroy
  has_many :preapproval_payments, :dependent => :destroy

  attr_accessor :preapproval_pay, :initial_reward_amount
  attr_accessor :set_task_total_reward_done #hack fix for recurisve set_task_total_reward => set_total_reward! bug

  def user_has_a_submission?(user)
    !submissions.select{|s|s.profile_id == user.profile_id}.blank?
  end
  
  def add_user_to_working_on(user)
    self[:users_ids_working_on_this] = [] if self[:users_ids_working_on_this].blank?
    self[:users_ids_working_on_this] << user.profile.id.to_s
    save
  end
  
  def remove_user_from_working_on(user)
    self[:users_ids_working_on_this] = [] if self[:users_ids_working_on_this].blank?
    self[:users_ids_working_on_this].delete(user.profile.id.to_s)
    save
  end
  
  def is_user_working_on?(user)
    self[:users_ids_working_on_this] = [] if self[:users_ids_working_on_this].blank?
    self[:users_ids_working_on_this].include?(user.profile.id.to_s)
  end
  
  def users_working_on_this_without_submissions
    self[:users_ids_working_on_this] = [] if self[:users_ids_working_on_this].blank?
    
    users = []
    
    self[:users_ids_working_on_this].each do |user_profile_id|
      profile = Profile.find(user_profile_id)
      if profile && !self.user_has_a_submission?(profile.user)
        users << profile.user
      end
    end
    
    users
  end
  
  def self.expire_past_deadline!
    tasks_to_be_expired = Task.all(:conditions => {:deadline_date  => {"$lt" => Time.now },
                                            :status => {"$ne" => Constants::TaskStatus::EXPIRED}},
                      :limit => 100)
    
    tasks_to_be_expired.each(&:expire!)
  end

  def self.categories
    Constants::CATEGORIES
  end

  def self.computer_languages
    Constants::COMPUTER_LANGUAGES
  end

  def self.default_license
    Constants::DEFAULT_LICENSE
  end

  def self.open_source_licenses
    #hard coded to retain ordering
    Constants::OPEN_SOURCE_LICENSES
  end

  def self.open_source_license_links
    Constants::OPEN_SOURCE_LICENSE_LINKS
  end

  def self.solution_formats
    Constants::SOLUTION_FORMATS
  end

  def format_tags
    return if self[:tags].blank?
    
    if self[:tags].is_a?(Array)
      self[:tags] = StringUtils.separate(self[:tags][0]) if self[:tags].length == 1
    else
      self[:tags] = StringUtils.separate(self[:tags])
    end
  end
  
  def date_added
    self[:created_at]
    #strftime(Constants::MONTH_DAY_YEAR_FORMAT)
  end

  def valid_preapproval_payments?
    pp = self.preapproval_payments
    return false if pp.empty?

    pp.each do |p|
      return true if p[:preapproval_key]
    end
    return false
  end

  def expire!
    if self.opened?
      self.status = Constants::TaskStatus::EXPIRED
      self.save(:validate => false)
    end
    
    set_no_users_working_on_this!
  end

  def expired?
    self.status == Constants::TaskStatus::EXPIRED || self[:deadline_date] < Time.now
  end
  
  def accepted_submission
    TaskSubmission.first(:task_id => self.id, :status => Constants::TaskSubmissionStatus::ACCEPTED)
  end

  def paid_submission
    TaskSubmission.first(:task_id => self.id, :status => Constants::TaskSubmissionStatus::PAID)
  end

  def complete!
    return if self.completed?

    #notify other contributors
    self.notify_all_task_rewarders
    
    ActivityItem.create_task_completed_event(profile, self)
    
    self.status = Constants::TaskStatus::COMPLETED
    self.save(:validate => false)
    
    set_no_users_working_on_this!
  end

  def notify_all_task_rewarders
    selected_submission = paid_submission
    if selected_submission
      self.rewards.each do |reward|
        unless reward.paid?
          UserNotifier.deliver_task_accepted_payment_required(reward, self, selected_submission)
        end
        reward_user = reward.profile.user
        UserNotifier.deliver_task_completed(self, selected_submission, reward_user) unless is_user_owner?(reward_user)
      end
    end
  end

  def completed?
    self.status == Constants::TaskStatus::COMPLETED
  end

  def canceled?
    self.status == Constants::TaskStatus::CANCELED
  end

  def opened?
    self.status == Constants::TaskStatus::OPEN
  end

  def is_user_owner?(user)
    return false unless user
    self[:profile_id].to_s == user.profile_id.to_s
  end

  def is_user_rewarder?(user)
    return false unless user
    self.rewards.collect(&:profile_id).include?(user.profile_id)
  end


  def create_first_reward
    t = TaskReward.new({:profile_id => self[:profile_id],
                       :task_id => self.id,
                       :amount => self.initial_reward_amount})
    t.save
  end

  def add_to_reward!(amount)
    self.total_reward = 0 unless self.total_reward
    self.total_reward += amount
    self.save(:validate => false)
  end

  def normalize_deadline
    year = self[:deadline_date].year
    month = self[:deadline_date].month
    day = self[:deadline_date].day

    self[:deadline_date] = Time.utc(year, month, day, 23, 59, 59, 1)
  end

  def validate_initial_amount
    if initial_reward_amount.nil? || initial_reward_amount.to_f <= 0
      errors.add(:initial_amount, "must be a valid number.")
    end
  end

  def validate_no_submissions
    raise NextSprocketErrors::SubmissionsNotEmpty if !self.submissions.empty?
  end

  def validate_deadline
    if self[:deadline_date] && self[:deadline_date] - 3.days.from_now  < 0
      errors.add(:deadline, "must more than 3 days from now.")
    end
  end

  def email_creator
    UserNotifier.deliver_new_task(self)
  end

  def sync_submissions_count!
    self[:submissions_count] = self.submissions.count
    self.save(:validate =>false)
  end
  
  private
  
  def create_activity_item
    ActivityItem.create_task_created_event(profile, self)
  end
  
  def set_no_users_working_on_this!
    self[:users_ids_working_on_this] = []
    self.save(:validate => false)
  end
end
