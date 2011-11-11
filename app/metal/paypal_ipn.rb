# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class PaypalIpn
  #TODO need to consider IPN when
  # user cancels a preapproval payment, it should destroy the PreapprovalPayment object

  # IPN  not used for payment validation; payment validation used by payment#payment_status_from_paypal
  # below not working correctly.
  def self.call(env)
    if env["PATH_INFO"] =~ /^\/paypal_ipn/
      request = Rack::Request.new(env)
      params = request.params

      if request.post?
        ipn = PaypalAdaptive::IpnNotification.new
        Rails.logger.error('-----------------')
        Rails.logger.error('IPN message start')
        Rails.logger.error("#{env['rack.request.query_string']}")
        ipn.send_back(env['QUERY_STRING'])
        Rails.logger.error("Sending back")

        if ipn.verified?
          #mark transaction as completed in your DB
          output = "Verified."
          if params['status'] == 'COMPLETED'
             payment = Payment.first(:paypal_pay_key => params['payKey'])
             payment.update_attributes(:paid => true)
          end
        else
          output = "Not Verified."
        end
        Rails.logger.error("IPN output: #{output}")
        Rails.logger.error('-----------------')
      end
      
      [200, {"Content-Type" => "text/html"}, [output]]
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end
end