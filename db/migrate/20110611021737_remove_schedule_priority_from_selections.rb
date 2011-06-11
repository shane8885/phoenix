class RemoveSchedulePriorityFromSelections < ActiveRecord::Migration
  def self.up
    remove_column :selections,:schedule_priority
  end

  def self.down
    add_column :selections, :schedule_priority, :integer
  end
end
