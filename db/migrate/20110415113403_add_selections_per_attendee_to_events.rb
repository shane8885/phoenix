class AddSelectionsPerAttendeeToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :selections_per_attendee, :integer, :default => 10
  end

  def self.down
    remove_column :events, :selections_per_attendee
  end
end
