module TasksHelper
  def degrading_into_video_js
    "$.modal('<div style=\"padding:10px;\"><object width=\"730\" height=\"456\"><param name=\"allowfullscreen\" value=\"true\" /><param name=\"allowscriptaccess\" value=\"always\" /><param name=\"movie\" value=\"http://vimeo.com/moogaloop.swf?clip_id=9612785&amp;server=vimeo.com&amp;show_title=0&amp;show_byline=0&amp;show_portrait=0&amp;color=00ADEF&amp;fullscreen=1\" /><embed src=\"http://vimeo.com/moogaloop.swf?clip_id=9612785&amp;autoplay=1&amp;server=vimeo.com&amp;show_title=0&amp;show_byline=0&amp;show_portrait=0&amp;color=00ADEF&amp;fullscreen=1\" type=\"application/x-shockwave-flash\" allowfullscreen=\"true\" allowscriptaccess=\"always\" width=\"730\" height=\"456\"></embed></object></div>');return false"
  end
  
  def new_task_step1_validation_js
  txt =<<EOS
    $('#new_task').validate({
    	rules: {
    		'task[title]': {
    		  required: true,
    		  minlength: 5,
    		  maxlength: 60
    		},
    		'task[description]': {
    		  required: true,
    		  minlength: 10,
    		  maxlength: 400
    		}
    	},
    	messages: {
    		'task[title]': {
    		  required: 'Please enter a title for the task'
    		},
    		'task[description]': {
    		  required: 'Please enter a description of the task'
    		}
    	},
      errorPlacement: function(error, element) {
      	if ( element.is(":radio") )
      		error.appendTo( element.parent().next().next() );
      	else if ( element.is(":checkbox") )
      		error.appendTo ( element.next() );
      	else
      		error.appendTo( element.parent().next().html('') );
      }
    });
EOS
  end
  
  def new_task_step2_validation_js
  txt =<<EOS
    $('#new_task').validate({
    	rules: {
    		'task[requirements]': {
    		  required: true,
    		  minlength: 10,
    		},
    		'task[associated_project_name]': {
    		  required: true
    		}
    	},
    	messages: {
    	  'task[requirements]': {
    		  required: 'Please enter a the requirements for the task'
    		},
    		'task[associated_project_name]': {
    		  required: 'Please enter the name of the associated project for the task'
    		}
    	},
      errorPlacement: function(error, element) {
      	if ( element.is(":radio") )
      		error.appendTo( element.parent().next().next() );
      	else if ( element.is(":checkbox") )
      		error.appendTo ( element.next() );
      	else
      		error.appendTo( element.parent().next().html('') );
      }
    });
EOS
  end
  
  def link_to_task_submission(task, task_submission)
    if task.is_user_owner?(current_user) || task_submission.is_user_owner?(current_user) || task_submission.paid?
      task_submission_path(task, task_submission)
    else
      "javascript:alert('This solution is unavailable until this task submitter has been paid.')"
    end
  end
  
  def no_results_tasks_search_msg(tasks_filter)
    msg = "No tasks found"
    msg = "#{msg} for \'#{tasks_filter.terms}\'" unless tasks_filter.terms.blank?
    msg = "#{msg} in #{tasks_filter.category}" unless tasks_filter.category.blank?
    msg = "#{msg} for #{tasks_filter.programming_language}" unless tasks_filter.programming_language.blank?
    
    if !tasks_filter.reward_low.blank? && !tasks_filter.reward_high.blank?
      msg = "#{msg} between $#{tasks_filter.reward_low} and $#{tasks_filter.reward_high}"
    elsif !tasks_filter.reward_low.blank?
      msg = "#{msg} with reward more than $#{tasks_filter.reward_low}"
    elsif !tasks_filter.reward_high.blank?
      msg = "#{msg} with reward less than $#{tasks_filter.reward_high}"
    end
    
    "#{msg}."
  end
  
  def find_query_url(term_query, new_condition)
    term_query = "" unless term_query
    options = {}
    options[:q] = term_query unless term_query.blank?
    options[:category] = params[:category]
    options[:computer_language] = params[:computer_language]
    options[:total_reward] = params[:total_reward]
    options.merge!(new_condition)
    tasks_path(options)
  end

  def selected_filter_value_css_class(tasks_filter, filter, value)
    tasks_filter.send(filter) == value ? "selected" : nil  
  end

  def more_than_2_weeks_from(target_time)
    target_time - 2.weeks.from_now  > 0
  end

  def less_than_3_days_from(target_time)
    target_time - 3.days.from_now  < 0
  end

  def requirements_example_text
    txt =<<EOS
This is a sample you can base your requirements on.
-------------------------------------------------------------------
- A lexer/parser/translator approach to translating Markdown to HTML

- Input is text formatted in Markdown.
- Output is corresponding HTML code.

- Details of Markdown:
 http://daringfireball.net/projects/markdown
- Must be implemented with a automated modern lexer/parser tool.
These tools uses a grammar file to auto-generates the lexer/parser. Antlr is one example.\n
- Must pass the MarkdownTest unit tests as referenced here:
http://six.pairlist.net/pipermail/markdown-discuss/2004-December/000909.html
EOS
  end
end
