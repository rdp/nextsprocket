class FeedbacksController < ApplicationController
  include Recaptcha::Verify
  
  def new
    @feedback= Feedback.new
  end

  def create
    @feedback = Feedback.new(params[:feedback])

    if verify_recaptcha(:model => @feedback, :message => 'You failed to type in the same message.') && @feedback.save
      flash[:notice] = "We got your message!"
      redirect_to root_path
    else
      flash[:notice] = "Error sending your message."
      render 'home/contact_us'
    end
  end
end
