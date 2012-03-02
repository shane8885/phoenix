class UpgradeDeviseUser < ActiveRecord::Migration
  def self.up
    add_column :users, :reset_password_sent_at, :datetime
    remove_column :users, :remember_token
  end

  def self.down
    remove_column :users, :reset_password_sent_at
    add_column :users, :remember_token, :string
  end
end
