class AddSchedulePriorityToSelections < ActiveRecord::Migration
  def self.up
    add_column :selections, :schedule_priority, :integer, :default => 999
  end

  def self.down
    remove_column :selections, :schedule_priority
  end
end
