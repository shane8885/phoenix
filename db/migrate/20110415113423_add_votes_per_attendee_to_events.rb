class AddVotesPerAttendeeToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :votes_per_attendee, :integer, :default => 10
  end

  def self.down
    remove_column :events, :votes_per_attendee
  end
end
