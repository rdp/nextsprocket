class TaskSubmissionsController < ApplicationController
  before_filter :get_task
  before_filter :get_item
  before_filter :require_user, :only => [:new, :create, :edit, :destroy, :create_comment]

  def show
    unless @task.is_user_owner?(current_user) || @task_submission.is_user_owner?(current_user) || @task_submission.paid?
      flash[:error] = 'Sorry, the solution is not viewable until the submitter has been paid.'
      redirect_to(task_path(@task))
    end
    
    @task_submission.open! if @task.is_user_owner?(current_user) && @task_submission.unread?
  end

  def new
    redirect_to task_path(@task) if @task.completed?

    opts = {}
    @task_submission = TaskSubmission.new(opts)
  end

  def create
    redirect_to task_path(@task) if @task.completed?

    insert_attributes = {:profile_id => current_user.profile_id, :task_id => @task.id}
    @task_submission = TaskSubmission.new(params[:task_submission].merge(insert_attributes))

    if @task_submission.save
      render :action => :receipt
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @task_submission.is_user_owner?(current_user) &&
            @task_submission.update_attributes(params[:task_submission])
      flash[:notice] = "Task updated!"
      redirect_to task_submission_path(@task, @task_submission)
    else
      render :action => :edit
    end
  end

  def destroy
    if @task_submission.is_user_owner?(current_user) && @task_submission.destroy
      flash[:notice] = "Deleted"
    else
      flash[:error] = "Failed to delete."
    end
    redirect_to task_path(@task)
  end

  def get_task
    @task = Task.first(:permalink => params[:task_id]) || Task.find(params[:task_id])
  rescue Mongo::InvalidObjectID
    rescue_invalid_object
  end

  def get_item
    @task_submission = TaskSubmission.find(params[:id])
  rescue Mongo::InvalidObjectID
    rescue_invalid_object
  end

  def accept
    if @task.is_user_owner?(current_user) && @task_submission.accept!
      redirect_to new_payment_path(:task_submission_id => @task_submission.id)
    else
      flash[:error] = "Error accepting."
      redirect_to task_submission_path(@task, @task_submission)
    end
  end

  def reject
    if @task.is_user_owner?(current_user) && @task_submission.reject!
      flash[:notice] = "This submission has been rejected!"
    else
      flash[:error] = "Error rejecting."
    end

    redirect_to task_submission_path(@task, @task_submission)
  end

  def create_comment
    insert_attributes = {:profile_id => current_user.profile_id,
                         :content => params[:content],
                         :created_at => Time.now}
    comment = TaskSubmissionComment.new(insert_attributes)
    @task_submission.comments << comment

    if @task_submission.save      
      comment.email_creators!
      
      flash[:notice] = "Comment Posted!"
    else
      flash[:error] = "Error posting comment."
    end

    redirect_to task_submission_path(@task, @task_submission)
  end
end
