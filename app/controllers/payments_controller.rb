class PaymentsController < ApplicationController
  before_filter :get_item, :except => [:index]
  before_filter :require_user, :only => [:new, :create, :edit, :destroy]
  
  def index
    @sent_payments = current_user.profile.sent_payments
    @received_payments = current_user.profile.received_payments
  end
  
  def show

  end
  
  def new
    @task_submission = TaskSubmission.find(params[:task_submission_id])
    @task = @task_submission.task
    @preapproval_payment = PreapprovalPayment.first({:sender_id => current_user.profile_id,
                                                                           :task_id => @task.id})
    @current_user_contribution = TaskReward.user_contributed_amount(@task,current_user)

    options = {:sender_id => current_user.profile_id,
               :receipient_id => @task_submission.profile_id,
               :task_submission_id =>@task_submission.id,
               :amount => @current_user_contribution }

    @payment = Payment.new(options)
  end

  def create
    @task_submission = TaskSubmission.find(params[:payment][:task_submission_id])
    @task = @task_submission.task

    insert_attributes = {:sender_id => current_user.profile_id}
    @payment = Payment.new(params[:payment].merge(insert_attributes))

    if @payment.save
      paypal_confirm_url = @payment.pay

      if paypal_confirm_url
         redirect_to paypal_confirm_url
      else
         flash[:error] = @payment.paypal_errors
         render :controller => :payments, :action => :new
      end
    else
      render :controller => :payments, :action => :new
    end
  end
  
  def edit
  end
  
  def update
    if @payment.update_attributes(params[:payment])
      flash[:notice] = "Payment updated!"
      redirect_to payment_path(@payment)
    else
      render :action => :edit
    end
  end
  
  def destroy
    if @payment.destroy
      flash[:notice] = "Deleted"
    else
      flash[:error] = "Failed to delete."
    end
    redirect_to root_path
  end

  def completed_paypal
    if @payment.confirm_payment!
      flash[:notice] = "Completed payment"
    else
      flash[:error] = "There was an error recording your payment. Please contact us."
    end

    redirect_to root_path
  end

  def canceled_paypal
    flash[:error] = "Canceled payment"
    redirect_to root_path
  end

  def get_item
    @payment = Payment.find(params[:id])
  end
end
