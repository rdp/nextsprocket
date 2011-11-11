require 'test_helper'

class TaskSubmissionTest < Test::Unit::TestCase
  include TasksHelper

  # Replace this with your real tests.
  def setup
    @task_submission = Factory.build(:task_submission)
  end

  def teardown
    @task_submission.destroy if @task_submission
  end

  def test_task_should_fail_save
    @task_submission = Task.new
    assert @task_submission.save == false
  end

  def test_open_set_open_at_time
    assert @task_submission.save
    assert_equal nil, @task_submission[:open_at]
    @task_submission.open!
    assert_not_nil @task_submission[:open_at]
  end

  def test_adjust_reputation_for_opened_and_ignored!
    assert @task_submission.save
    assert_equal nil, @task_submission[:open_at]
    @task_submission.open!

    TaskSubmission.adjust_reputation_for_opened_and_ignored!
 end

  def test_more_than_2_weeks_from
    assert_equal false, more_than_2_weeks_from(Time.now - 1.week)
    assert_equal false, more_than_2_weeks_from(Time.now)
    assert_equal true, more_than_2_weeks_from(Time.now + 3.weeks)
  end

  def test_user_cannot_be_task_creator
    @task_submission[:profile_id] = @task_submission.task[:profile_id]
    assert_equal false, @task_submission.save
  end
end
