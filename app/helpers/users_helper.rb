module UsersHelper
  def activity_item_event_valid?(ai)
    case ai.type.to_i
    when ActivityItem.types::TASK_CREATED
      !ai.profile.blank? && !ai.task.blank?
    when ActivityItem.types::TASK_SUBMISSION_ACCEPTED
      !ai.profile.blank? && !ai.task.blank? && !ai.task.profile.blank?
    when ActivityItem.types::TASK_COMPLETED
      !ai.task.blank?
    when ActivityItem.types::NEW_CONTRIBUTION
      !ai.profile.blank? && !ai.task_reward.blank? && !ai.task.blank?
    when ActivityItem.types::CREATOR_REWARD_INCREASED
      !ai.profile.blank? && !ai.task_reward.blank? && !ai.task.blank?
    when ActivityItem.types::NEW_TASK_COMMENT
      !ai.profile.blank? && !ai.task.blank?
    when ActivityItem.types::NEW_TASK_SUBMISSION_COMMENT
      !ai.profile.blank? && !ai.task.blank? && !ai.task_submission.blank? && !ai.task_submission.profile.blank?
    when ActivityItem.types::NEW_TASK_SUBMISSION
      !ai.profile.blank? && !ai.task.blank? && !ai.task_submission.blank?
    when ActivityItem.types::NEW_USER
      !ai.profile.blank?
    else
      # "Unable to render activity item."
      true
    end
  end
  
  def activity_item_event_parser(ai)
    case ai.type.to_i
    when ActivityItem.types::TASK_CREATED
      ai_profile_avatar = gravatar_image_tag(ai.profile.email, :alt => ai.profile[:name], :gravatar => { :size => 20} , :class => "avatar")
      "#{ai_profile_avatar} #{link_to(ai.profile.name, ai.profile)} created a new task \"#{link_to(ai.task.title, ai.task)}\" under #{ai.task.category}."
    when ActivityItem.types::TASK_SUBMISSION_ACCEPTED
      ai_profile_avatar = gravatar_image_tag(ai.profile.email, :alt => ai.profile[:name], :gravatar => { :size => 20} , :class => "avatar")
      ai_task_profile_avatar = gravatar_image_tag(ai.task.profile.email, :alt => ai.task.profile[:name], :gravatar => { :size => 20} , :class => "avatar")
      "#{ai_task_profile_avatar} #{ai.task.profile.name} accepted #{ai_profile_avatar} #{link_to(ai.profile.name, ai.profile)}'s solution for the task \"#{link_to(ai.task.title, ai.task)}.\""
    when ActivityItem.types::TASK_COMPLETED
      "The task \"#{link_to(ai.task.title, ai.task)}\" has an open source solution and is now completed."
    when ActivityItem.types::NEW_CONTRIBUTION
      ai_profile_avatar = gravatar_image_tag(ai.profile.email, :alt => ai.profile[:name], :gravatar => { :size => 20} , :class => "avatar")
      "#{ai_profile_avatar} #{link_to(ai.profile.name, ai.profile)} contributed $#{ai.task_reward.amount} to the reward for the task \"#{link_to(ai.task.title, ai.task)}.\""
    when ActivityItem.types::CREATOR_REWARD_INCREASED
      ai_profile_avatar = gravatar_image_tag(ai.profile.email, :alt => ai.profile[:name], :gravatar => { :size => 20} , :class => "avatar")
      "#{ai_profile_avatar} #{link_to(ai.profile.name, ai.profile)} increased the reward for the task \"#{link_to(ai.task.title, ai.task)}\" to $#{ai.task_reward.amount}."
    when ActivityItem.types::NEW_TASK_COMMENT
      ai_profile_avatar = gravatar_image_tag(ai.profile.email, :alt => ai.profile[:name], :gravatar => { :size => 20} , :class => "avatar")
      "#{ai_profile_avatar} #{link_to(ai.profile.name, ai.profile)} commented on the task \"#{link_to(ai.task.title, ai.task)}.\""
    when ActivityItem.types::NEW_TASK_SUBMISSION_COMMENT
      ai_profile_avatar = gravatar_image_tag(ai.profile.email, :alt => ai.profile[:name], :gravatar => { :size => 20} , :class => "avatar")
      "#{ai_profile_avatar} #{link_to(ai.profile.name, ai.profile)} commented on #{ai.task_submission.profile.name}'s solution for the task \"#{link_to(ai.task.title, ai.task)}.\""
    when ActivityItem.types::NEW_TASK_SUBMISSION
      ai_profile_avatar = gravatar_image_tag(ai.profile.email, :alt => ai.profile[:name], :gravatar => { :size => 20} , :class => "avatar")
      "#{ai_profile_avatar} #{link_to(ai.profile.name, ai.profile)} submitted a #{link_to('solution', task_submission_path(ai.task, ai.task_submission))} to the task \"#{link_to(ai.task.title, ai.task)}.\""
    when ActivityItem.types::NEW_USER
      ai_profile_avatar = gravatar_image_tag(ai.profile.email, :alt => ai.profile[:name], :gravatar => { :size => 20} , :class => "avatar")
      "#{ai_profile_avatar} #{link_to(ai.profile.name, ai.profile)} joined Next Sprocket, sweet!"
    else
      "Unable to render activity item."
    end
  end
end