class HomeController < ApplicationController
  def index
    @tasks = Task.all(:limit => 10)
  end

  def about
    
  end

  def how_it_works

  end

  def contact_us
    @feedback = Feedback.new
  end
end
