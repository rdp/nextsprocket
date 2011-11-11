require 'test_helper'

class ReputationTest < Test::Unit::TestCase
  def setup
    #need to drop test db since a lot of left over associated items remain
    Task.collection.drop
    
    @sender = Factory.build(:profile)
    @recipient = Factory.build(:profile)
    @task = Factory.create(:task, :profile => @sender)
    @task_submission = Factory.build(:task_submission, :task => @task, :profile => @recipient)
    @payment = Factory.build(:payment, {:sender => @sender,
                            :recipient =>@recipient,
                            :task_submission => @task_submission})

    assert_prereq_objects
  end

  def teardown
    @sender.destroy if @sender
    @recipient.destroy if @recipient
    @task_submission.destroy if @task_submission
    @task.destroy if @task
    @payment.destroy if @payment
  end

  def assert_prereq_objects
    assert @sender.id, @sender.errors.full_messages
    assert @recipient.id, @recipient.errors.full_messages
    assert @task.id, @task.errors.full_messages
    assert @task_submission.id, @task_submission.errors.full_messages
    assert_not_nil @task_submission.task
    assert_not_nil @task_submission.task.profile
  end

  def test_paid_for_submission
    assert  Reputation.paid_for_submission(@payment)
    assert  @payment.sender.reputation.records.size == 1
    points = @payment.sender.reputation_points
    assert_equal Constants::ReputationPoints::PAID_FOR_SUBMISSION, points
  end

  def test_paid_for_submission_reject_duplicate
    assert Reputation.paid_for_submission(@payment)
    points = @payment.sender.reputation_points 
    assert_equal Constants::ReputationPoints::PAID_FOR_SUBMISSION, points

    Reputation.paid_for_submission(@payment)
    assert_equal points, @payment.sender.reputation_points
    assert  @payment.sender.reputation.records.size == 1    
  end

  def test_reject_a_submission
    assert Reputation.rejected_submission_without_reason(@task_submission)
    task = Task.find(@task_submission[:task_id])
    task_creator = Profile.find(task[:profile_id])
    points = task_creator.reputation_points
    assert_equal Constants::ReputationPoints::REJECTED_SUBMISSION_WITHOUT_REASON, points
    assert  @payment.sender.reputation.records.size == 1
  end

  def test_accept_submission
    assert Reputation.task_submission_accepted(@task_submission)
    points = @task_submission.profile.reputation_points
    assert_equal Constants::ReputationPoints::TASK_SUBMISSION_ACCEPTED, points
    assert  @task_submission.profile.reputation.records.size == 1  
  end

  def test_opened_and_ignored_submission
    #don't change points since ignored isn't set until two weeks after being open
    Reputation.opened_and_ignored_submission(@task_submission)
    points = @task_submission.task.profile.reputation_points
    assert_equal 0, points

    #this should change the reputation
    #adjust date so it's two weeks past open_at
    @task_submission.open!
    @task_submission[:open_at] = 3.weeks.ago
    @task_submission.save

    Reputation.opened_and_ignored_submission(@task_submission)
    task = Task.find(@task_submission[:task_id])
    task_creator = Profile.find(task[:profile_id])
    points = task_creator.reputation_points
    assert_equal Constants::ReputationPoints::OPENED_AND_IGNORED_SUBMISSION, points
    assert task_creator.reputation.records.size == 1

    #should not decrease the reputation again
    Reputation.opened_and_ignored_submission(@task_submission)
    task = Task.find(@task_submission[:task_id])
    task_creator = Profile.find(task[:profile_id])
    points = task_creator.reputation_points
    assert_equal Constants::ReputationPoints::OPENED_AND_IGNORED_SUBMISSION, points
    assert task_creator.reputation.records.size == 1
  end

end
