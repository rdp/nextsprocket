namespace :task_status do
  desc 'Expire tasks past deadline date'
  task :expire_old => :environment do
   puts "Expiring tasks.."
   Task.expire_past_deadline!
   puts "Call complete."
  end

  desc 'Adjust task creator points when open but ignore a task submission'
  task :open_and_ignored_task_submissions => :environment do
   puts "Adjusting task creator points.."
   TaskSubmission.adjust_reputation_for_opened_and_ignored!
   puts "Call complete."
  end
end