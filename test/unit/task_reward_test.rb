require 'test_helper'

class TaskRewardTest  < Test::Unit::TestCase
  def setup
    @task_reward = Factory.build(:task_reward)
  end

  def teardown
    @task_reward.destroy if @task_reward
  end

  def test_amount_not_less_than_starting_amount
    assert @task_reward.save
    assert_equal false, @task_reward.update_attributes({:amount=> @task_reward[:amount] - 10})
  end

  def test_preapproval_cant_change_amount
    @task_reward[:preapproval] = true

    assert @task_reward.save
    assert_equal false, @task_reward.update_attributes({:amount=> 200})
  end

end