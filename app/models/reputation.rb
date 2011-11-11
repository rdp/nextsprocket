class Reputation
  include MongoMapper::Document

  key :profile_id, ObjectId, :required => true
  has_many :records, :class_name => 'ReputationRecord'
  belongs_to :profile

  def record_stats
    stats = {}
    stats[:paid_for_submission] = 0
    stats[:rejected_submission_without_reason] = 0
    stats[:task_submission_accepted] = 0

    self.records.each do |r|
      case r.action_code
        when Constants::ReputationActionCode::PAID_FOR_SUBMISSION
          stats[:paid_for_submission] += 1
        when Constants::ReputationActionCode::REJECTED_SUBMISSION_WITHOUT_REASON
          stats[:rejected_submission_without_reason] += 1
        when Constants::ReputationActionCode::TASK_SUBMISSION_ACCEPTED
          stats[:task_submission_accepted] += 1
      end
    end
  stats
 end

  #possible actions:
  # +1 for paying for a submission
  # -5 for rejecting a submission without a reason
  # +2 for having a submission accepted
  def self.paid_for_submission(payment)
    task_submission = payment.task_submission
    profile = payment.sender
    reputation = profile.reputation
    reputation ||= Reputation.create(:profile_id => profile.id)
    
    found_records = reputation.records.select{|record|
                !record.task_submission_id.nil? && record.task_submission_id == task_submission.id }
    return false unless found_records.empty?

    profile.reputation_points += Constants::ReputationPoints::PAID_FOR_SUBMISSION
    profile.save
    
    reputation.records << ReputationRecord.new(:action_code => Constants::ReputationActionCode::PAID_FOR_SUBMISSION,
                                               :task_submission_id => task_submission.id)
    reputation.save
  end

  def self.rejected_submission_without_reason(task_submission)
    parent_task = Task.find(task_submission[:task_id])
    task_creator = Profile.find(parent_task[:profile_id])
    raise "task submission does not have profile" if task_creator.nil?
    
    reputation = task_creator.reputation
    reputation ||= Reputation.create(:profile_id => task_creator.id)

    task_creator[:reputation_points] += Constants::ReputationPoints::REJECTED_SUBMISSION_WITHOUT_REASON
    task_creator.save
    
    reputation.records << ReputationRecord.new(:action_code => Constants::ReputationActionCode::REJECTED_SUBMISSION_WITHOUT_REASON,
                                               :task_submission_id => task_submission.id)
    reputation.save
  end

  def self.opened_and_ignored_submission(task_submission)
    parent_task = Task.find(task_submission[:task_id])
    task_creator = Profile.find(parent_task[:profile_id])
    #task_creator= task_submission.task.profile #fails in unit tests... mongomapper bug?
    raise "task submission does not have profile" if task_creator.nil?

    #TODO: if submission has been opened and the task creator hasn't commented or accepted/rejected in 2 weeks
    if task_submission.opened? && task_submission.comments.empty? && !task_submission.ignored_once_by_task_creator?
      task_submission.update_attributes(:ignored_once => true)

      reputation = task_creator.reputation
      reputation ||= Reputation.create(:profile_id => task_creator.id)

      task_creator[:reputation_points] += Constants::ReputationPoints::OPENED_AND_IGNORED_SUBMISSION
      task_creator.save

      reputation.records << ReputationRecord.new(:action_code => Constants::ReputationActionCode::OPENED_AND_IGNORED_SUBMISSION ,
                                                 :task_submission_id => task_submission.id)
      reputation.save
    end
 end

  def self.task_submission_accepted(task_submission)
    profile = task_submission.profile
    reputation = profile.reputation
    reputation ||= Reputation.create(:profile_id => profile.id)

    profile.reputation_points += Constants::ReputationPoints::TASK_SUBMISSION_ACCEPTED
    profile.save
    
    reputation.records << ReputationRecord.new(:action_code => Constants::ReputationActionCode::TASK_SUBMISSION_ACCEPTED,
                                               :task_submission_id => task_submission.id)
    reputation.save
  end
end
