class AddColumnsToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :description, :string, :default => 'No Description.'
    add_column :events, :selections_deadline, :date
    add_column :events, :votes_deadline, :date
  end

  def self.down
    remove_column :events, :votes_deadline
    remove_column :events, :selections_deadline
    remove_column :events, :description
  end
end
