class AddPositionToSelections < ActiveRecord::Migration
  def self.up
    add_column :selections, :position, :integer
  end

  def self.down
    remove_column :selections, :position
  end
end
