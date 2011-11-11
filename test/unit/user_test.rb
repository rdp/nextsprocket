require 'test_helper'

class UserTest < Test::Unit::TestCase
  def setup
    @user = Factory.build(:user)
  end

  def teardown
    @user.destroy if @user && !@user.new_record?
  end

  def test_user_save_should_create_profile
    assert @user.save, "#{@user.errors.full_messages}"
    assert @user.profile
    @user = User.find(@user.id)
  end

  def test_user_update
    assert @user.save
    
    @user.name = nil
    assert @user.save, "#{@user.errors.full_messages}"    
  end

  def test_name_is_unique
    assert @user.save
    @two_user = Factory.build(:user, :name => @user.name)

    assert_equal false,  @two_user.save    
  end

  def test_destroy_will_delete_associated_items
    #reputation
    #tasks
    #task rewards
    #task submissions
    #task comments
  end
end
