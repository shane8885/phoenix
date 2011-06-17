class AddPositionToSelections < ActiveRecord::Migration
  def self.up
    add_column :selections, :position, :integer, :default => 1
  end

  def self.down
    remove_column :selections, :position
  end
end
