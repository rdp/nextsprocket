class AddUserType < ActiveRecord::Migration
  def self.up
    add_column :users, :user_type, :integer, :size => 1, :default => false, :null => false
  end

  def self.down
    remove_column :users, :user_type
  end
end
