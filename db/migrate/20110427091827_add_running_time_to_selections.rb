class AddRunningTimeToSelections < ActiveRecord::Migration
  def self.up
    add_column :selections, :running_time, :integer, :default => 0
  end

  def self.down
    remove_column :selections, :running_time
  end
end
