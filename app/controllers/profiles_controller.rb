class ProfilesController < ApplicationController
  def index
    @profiles = Profile.paginate(:page =>params[:page], :limit =>10)
  end

  def show
    @profile = Profile.first(:permalink => params[:id]) || Profile.find(params[:id])
    raise Mongo::InvalidObjectID if @profile == nil
    
    @reputation_stats = @profile.reputation.record_stats rescue {}    
    task_ids = @profile.tasks.collect{|t|"'#{t.id}'"}.join(',')
    task_submissions_ids = @profile.task_submissions.collect{|ts|"'#{ts.id}'"}.join(',')
    @activity_items = ActivityItem.paginate('$where' => "function() { return (this.profile_id == '#{@profile.id}') || ([#{task_ids}].indexOf(this.task_id + '') != -1) || ([#{task_submissions_ids}].indexOf(this.task_submission_id + '') != -1); }", :order => 'created_at desc', :per_page => 15, :page => 1)
  rescue Mongo::InvalidObjectID
    rescue_invalid_object
  end
end
