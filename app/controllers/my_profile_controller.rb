class MyProfileController < ApplicationController
  before_filter :require_user
  
  def show
    @profile = Profile.find(current_user.profile_id)
    @reputation_stats = @profile.reputation.record_stats rescue {}
    
    task_ids = @profile.tasks.collect{|t|"'#{t.id}'"}.join(',')
    task_submissions_ids = @profile.task_submissions.collect{|ts|"'#{ts.id}'"}.join(',')
    @activity_items = ActivityItem.paginate('$where' => "function() { return (this.profile_id == '#{@profile.id}') || ([#{task_ids}].indexOf(this.task_id + '') != -1) || ([#{task_submissions_ids}].indexOf(this.task_submission_id + '') != -1); }", :order => 'created_at desc', :per_page => 15, :page => 1)
  end

  def edit
    @profile = Profile.find(current_user.profile_id)
  end

  def update
    @profile = current_user.profile
    if @profile.update_attributes(params[:profile])
      flash[:notice] = "Profile updated!"
      redirect_to my_profile_path
    else
      render :action => :edit
    end
  end

end
