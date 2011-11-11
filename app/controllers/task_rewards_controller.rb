class TaskRewardsController < ApplicationController
  before_filter :get_task
  before_filter :get_item, :except => [:index]
  before_filter :require_user, :only => [:new, :create, :edit, :destroy]

  def index
    @task_rewards = @task.rewards.paginate(:page => 1, :limit => 10, :order => 'created_at desc')
  end

  def show
  end

  def new
    opts = {}
    @task_reward = TaskReward.new(opts)
  end

  def create
    insert_attributes = {:profile_id => current_user.profile_id, :task_id => @task.id}
    @task_reward = TaskReward.new(params[:task_reward].merge(insert_attributes))

    if @task_reward.save
      flash[:notice] = 'You have posted a reward for the task.'
      redirect_to task_path(@task)
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @task_reward.is_user_owner?(current_user) &&
            @task_reward.update_attributes(params[:task_reward])
      flash[:notice] = "Task updated!"
      
      redirect_to task_path(@task)
    else
      render :action => :edit
    end
  end

  def destroy
    if @task_reward.is_user_owner?(current_user) && @task_reward.destroy
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
    @task_reward = TaskReward.find(params[:id])
  rescue Mongo::InvalidObjectID
    rescue_invalid_object
  end
end
