class PreapprovalPaymentsController < ApplicationController
  before_filter :require_user
  def completed_paypal
    preapproval_payment = PreapprovalPayment.find(params[:id])
    if preapproval_payment[:preapproval_key]
      preapproval_payment.complete_from_paypal!
    end
    
    flash[:notice] = "Pre-approved payment"
    redirect_to root_path
  end

  def canceled_paypal
    flash[:error] = "Canceled payment"
    redirect_to root_path
  end

end
