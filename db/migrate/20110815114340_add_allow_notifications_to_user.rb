class AddAllowNotificationsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :allow_notifications, :boolean, :default => true
  end

  def self.down
    remove_column :users, :allow_notifications
  end
end
