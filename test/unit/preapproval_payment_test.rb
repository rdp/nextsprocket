require 'test_helper'

class PreapprovalPaymentTest  < Test::Unit::TestCase
  def setup
    @preapproval_payment = Factory.build(:preapproval_payment)
  end

  def teardown
    @preapproval_payment.destroy if @preapproval_payment
  end

  def test_save_should_fail
    @preapproval_payment[:amount] = nil
    assert_equal false, @preapproval_payment.save
  end
end
