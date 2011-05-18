class AddOpenForSelectionsToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :open_for_selections, :boolean, :default => true
  end

  def self.down
    remove_column :events, :open_for_selections
  end
end
