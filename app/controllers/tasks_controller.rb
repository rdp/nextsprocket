class TasksController < ApplicationController
  before_filter :get_item, :except => [:index]
  before_filter :require_user, :only => [:new, :create, :edit, :destroy, :create_comment]
  
  def index
    @tasks_filter = TasksFilter.new(params[:tasks_filter])
    
    order = case params[:sort]
    when "reward"
      "total_reward desc"
    when "deadline"
      "deadline_date"
    when "submissions"
      "submissions_count desc"
    else
      "created_at desc"
    end

    @tasks_filter.status = Constants::TaskStatus::OPEN if params[:sort] == "deadline"

    @tasks = Task.paginate(:conditions => @tasks_filter.to_finder_options,
                           :order => order,
                           :page => params[:page], :per_page => 12)
    
    
    respond_to { |format| 
      format.html {
        @computer_languages_filters = Task.computer_languages.sort.collect { |lang|
          tasks_filter = @tasks_filter.clone
          tasks_filter.programming_language = lang
          results_count = Task.count(:conditions => tasks_filter.to_finder_options)
          {:lang => lang, :results_count => results_count}
        }

        @categories_filters = Task.categories.sort.collect { |cat|
          tasks_filter = @tasks_filter.clone
          tasks_filter.category = cat
          results_count = Task.count(:conditions => tasks_filter.to_finder_options)
          {:cat => cat, :results_count => results_count}
        }

        @rewards_filters = TasksFilter.rewards.collect { |min, max|
          tasks_filter = @tasks_filter.clone
          tasks_filter.reward_low = min == -1 ? nil : min
          tasks_filter.reward_high = max == -1 ? nil : max
          results_count = Task.count(:conditions => tasks_filter.to_finder_options)
          {:min => min, :max => max, :results_count => results_count}
        }
      }
      format.rss {} 
    }
  end
  
  def show
    if @task.nil?
      flash[:error] = "Task not found!"
      flash[:alert] = "Task not found!"
      redirect_to "/"
    else
      opts = {}
      @comment = TaskComment.new(opts)
      @comments = @task.comments
      
      @preapproved = @task.valid_preapproval_payments?
      @task_submissions = @task.submissions

      @requestor_reputation_stats = @task.profile.reputation.record_stats
    end
  end
  
  def new
    opts = preprocess_date(params[:task])
    @task = Task.new(opts)
    
    case params[:step]
    when 'details'
      render :action => 'new/details'
    when 'pricing'
      render :action => 'new/pricing'
    else
      render :action => 'new'
    end
  end
  
  def create
    insert_attributes = {:profile_id => current_user.profile_id}
    params[:task] = preprocess_date(params[:task])
    @task = Task.new(params[:task].merge(insert_attributes))

    if @task.save
      if @task.preapproval_pay && @task.preapproval_pay == '1'
        create_preapproval_payment(current_user, @task)
      else
        flash[:notice] = "The task has been created!"
        redirect_to task_path(@task)
      end
    else
      render :action => :new
    end
  end
  
  def edit
  end
  
  def update
    params[:task] = preprocess_date(params[:task])
    
    if @task.is_user_owner?(current_user) && @task.update_attributes(params[:task])
      flash[:notice] = "Task updated!"
      redirect_to task_path(@task)
    else
      render :action => :edit
    end
  end
  
  def destroy
    if @task.is_user_owner?(current_user) && @task.destroy
      flash[:notice] = "Deleted"
      redirect_back_or_default tasks_path
    else
      flash[:error] = "Failed to delete."
      redirect_to edit_task_path(@task)
    end

  rescue NextSprocketErrors::SubmissionsNotEmpty
    flash[:error] = "Can't delete a task once an entry has been submitted."
    redirect_to edit_task_path(@task)
  end
  
  def working_on
    @task.add_user_to_working_on(current_user)
    redirect_to task_path(@task)
  end
  
  def not_working_on
    @task.remove_user_from_working_on(current_user)
    redirect_to task_path(@task)
  end
  
  def get_item
    @task = Task.first({:permalink => params[:id]}) || Task.find(params[:id])
  rescue Mongo::InvalidObjectID
    rescue_invalid_object
  end

  def preprocess_date(original_task)
    if original_task && original_task.include?('deadline_date(3i)') && original_task.include?('deadline_date(2i)') && original_task.include?('deadline_date(1i)')
      task = original_task.clone
      date = [task['deadline_date(2i)'], task['deadline_date(3i)'], task['deadline_date(1i)']].join("/")
      
      task[:deadline_date] = Date.parse(date)

      ['deadline_date(1i)', 'deadline_date(2i)', 'deadline_date(3i)'].each do |field|
        task.delete(field)
      end
      task
    else
      original_task
    end
  end

  def create_comment
    insert_attributes = {:profile_id => current_user.profile_id,
                         :content => params[:content],
                         :created_at => Time.now}
    comment = TaskComment.new(insert_attributes)
    @task.comments << comment

    if @task.save
      flash[:notice] = "Comment Posted!"
      ActivityItem.create_new_task_comment_event(current_user.profile, comment, @task)
      
      @task.rewards.each do |reward|
        if reward.profile.id != comment.profile.id
          UserNotifier.deliver_new_task_comment(@task, reward.profile.user, comment)
        end
      end
      
      @task.comments.each do |c|
        if c.profile.id != comment.profile.id
          UserNotifier.deliver_new_task_comment(@task, c.profile.user, comment)
        end
      end
    else
      flash[:error] = "Error posting comment."
    end

    redirect_to task_path(@task)
  end

  def create_preapproval_payment(sender, task)
    insert_attributes = {:sender_id => sender.profile_id,
                         :sender_email => sender.email,
                         :task_id => task.id,
                         :amount => task.initial_reward_amount,
                         :commision_amount => Payment.calc_commission(task.initial_reward_amount.to_f)}
    preapproval_payment = PreapprovalPayment.new(insert_attributes)

    if preapproval_payment.save
      paypal_confirm_url = preapproval_payment.preapprove_payment

      if paypal_confirm_url
         redirect_to paypal_confirm_url
      else
        flash[:error] = "Error processing payment via paypal. "
        redirect_to task_path(task)
      end
    else
      flash[:error] = "There was an error creating your preapproval payment!"
      redirect_to task_path(task)
    end
  end
end
