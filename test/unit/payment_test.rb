require 'test_helper'

class PaymentTest  < Test::Unit::TestCase
  def setup
    @payment = Factory.build(:payment,
    :sender => Factory.create(:profile),
    :recipient => Factory.create(:profile),
    :task_submission=> Factory.create(:task_submission)
    )
  end

  def teardown
    @payment.destroy if @payment
  end

  def test_correct_commission_charged
    @payment[:amount] = 100
    @payment.set_commission_amount

    assert_equal (@payment[:amount] *COMMISSION_PERCENTAGE).round(2), @payment[:commission_amount]
  end

end
