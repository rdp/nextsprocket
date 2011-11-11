# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include Recaptcha::ClientHelper
  
  def javascript_includes
    files = ['jquery', 'jquery-ui.js', 'jrails',
      'jquery.validate.pack', 'jquery.simplemodal-1.3.3.min', 'application.js']
    javascript_include_tag(files, :cache => "_javascript")
  end
  
  def stylesheets_includes
    # ie_css = "<!--[if IE 6]>#{stylesheet_link_tag('ie6', 'ie-modalbox.css')}<![endif]--><!--[if IE 7]>#{stylesheet_link_tag('ie', 'ie-modalbox.css')}<![endif]-->"
    
    ie6_css = "<!--[if IE 6]>#{stylesheet_link_tag('ie6')}<![endif]-->"
    ie7_css = "<!--[if IE 7]>#{stylesheet_link_tag('ie', 'ie-modalbox')}<![endif]-->"
    
    files = ['reset', 'text', 'grid', 'master']
    cached_css = stylesheet_link_tag(files, :cache => "_stylesheet")
    cached_css + ie6_css + ie7_css
  end

  def page_title(full_page_title, page_title)
    return full_page_title if full_page_title
    page_title ? "#{page_title} : #{ t(:'site-name') }"  : t(:'site-name')
  end
  
  def degrading_login_js
    '$("#login-modalbox-content").modal();return false;'
  end
  
  def degrading_signup_js
    '$("#signup-modalbox-content").modal();return false;'
  end
  
  def icon_for_reputation_points(points)
    if points > 0
      image_tag('green_arrow.png')
    elsif points == 0
      image_tag('grey_arrow.png')
    else
      image_tag('red_cross.png')
    end
  end
  
  def icon_for_paid_for_stats(num)
    if num > 0
      image_tag('green_arrow.png')
    elsif num == 0
      image_tag('grey_arrow.png')
    else
      image_tag('red_cross.png')
    end
  end
  
  def icon_for_rejected_without_reason_stats(num)
    if num == 0
      image_tag('green_arrow.png')
    else
      image_tag('red_cross.png')
    end
  end
  
  def icon_for_task_submissions_accepted_stats(num)
    if num > 0
      image_tag('green_arrow.png')
    else
      image_tag('grey_arrow.png')
    end
  end
end
