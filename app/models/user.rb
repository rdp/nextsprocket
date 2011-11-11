class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = :email
  end
  
  after_create :create_profile
  after_create :create_activity_item
  before_destroy :destroy_profile

  validates_presence_of :name, :on => :create
  # validate_on_create :name_is_unique

  attr_accessor :name
  attr_protected :user_type

  # def name_is_unique
  #   found_profile = Profile.first(:name => self.name)
  #   if found_profile && found_profile.user_id != self[:id]
  #     errors.add_to_base("There is someone already registered with this name.") 
  #   end
  # end

  def profile
    Profile.find(self.profile_id)
  end
  
  def destroy_profile
    unless self[:profile_id].blank?
      p = Profile.find(self[:profile_id])
      p.destroy if p
    end
  end

  def admin?
    self.user_type == 1
  end
  
  private
  
  def create_profile
    profile = Profile.create({:user_id => self.id, :name => self.name})
    self.update_attribute(:profile_id, profile.id.to_s)
  end
  
  def create_activity_item
    ActivityItem.create_new_user_event(self.profile)
  end
end
