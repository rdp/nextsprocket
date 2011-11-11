class UserNotifier < ActionMailer::Base
  def new_task(task)
    setup_email(task.profile.user)
    @subject     = "New task created on NextSprocket!"
    @body[:task] = task
    @body[:bitly_url] = Rails.env == 'production' ? bitly_url_for(task) : 'http://bit.ly/test-url'
  end
  
  def new_task_submission(ts)
    setup_email(ts.task.profile.user)
    @subject     = "#{ts.profile.name} just submitted a solution for #{ts.task.title}!"
    @body[:ts] = ts
  end
  
  def new_task_comment(task, user, comment)
    setup_email(user)
    @subject            = "#{comment.profile.name} posted a new comment!"
    @body[:comment]     = comment
    @body[:task]        = task
  end
  
  def new_task_submission_comment(task, task_submission, user, comment)
    setup_email(user)
    @subject            = "#{comment.profile.name} posted a new comment!"
    @body[:comment]     = comment
    @body[:task]        = task
    @body[:task_submission] = task_submission
  end
  
  def task_completed(task, winning_submission, user_to_email)
    setup_email(user_to_email)
    @subject     = "A task has been completed on NextSprocket!"
    @body[:task]        = task
    @body[:submission]  = winning_submission
  end
  
  def task_accepted_payment_required(task_reward, task, task_submission)
    setup_email(task_reward.profile.user)
    @subject            = "A solution has been accepted for a task you contributed to!"
    @body[:task_reward] = task_reward
    @body[:task]        = task
    @body[:submission]  = task_submission
  end
  
  def new_feedback(feedback)
    setup_email_for_ns_team
    @subject        = feedback.title
    @body[:message] = feedback.message
    @body[:name]    = feedback.name
    @body[:email]   = feedback.email
  end

  protected
    def setup_email_for_ns_team
      @recipients  = "dev@nextsprocket.com"
      @from        = "no-reply@nextsprocket.com"
      @sent_on     = Time.now
    end
    
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "no-reply@nextsprocket.com"
      # @subject     = "NextSprocket - "
      @sent_on     = Time.now
      @body[:user] = user
    end

  def bitly_url_for(task)
    bitly = Bitly.new(BITLY_USERNAME, BITLY_APIKEY)
    bitly_url = bitly.shorten(task_url(task))
    bitly_url.short_url
  end
end
