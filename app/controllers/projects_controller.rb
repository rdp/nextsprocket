class ProjectsController < ApplicationController
  def index
    @projects = OpenSourceProject.paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @project = OpenSourceProject.find_by_permalink(params[:id])
    raise Mongo::InvalidObjectID if @project.nil?
  rescue Mongo::InvalidObjectID
    rescue_invalid_object
  end

end
