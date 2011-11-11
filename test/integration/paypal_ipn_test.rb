require "#{File.dirname(__FILE__)}/../test_helper"

class PaypalIpnTest < ActionController::IntegrationTest

  test "paypal ipn returns not verified" do
    post "/paypal_ipn"
    assert_response 200
    assert_response :success
    assert_response :ok
    assert_equal "Not Verified.", response.body
  end

  test "paypal ipn returns verified" do
    #TODO how to test?
  end

end