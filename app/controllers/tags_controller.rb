class TagsController < ApplicationController
  def index
    @task_tags = TaskTag.all_tags({:limit => 100})
  end
  
  def show
    @tag = params[:id]
    @tasks = Task.all(:tags => @tag, :limit => 100)
  end
end
