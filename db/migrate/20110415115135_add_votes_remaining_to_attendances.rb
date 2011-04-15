class AddVotesRemainingToAttendances < ActiveRecord::Migration
  def self.up
    add_column :attendances, :votes_remaining, :integer
  end

  def self.down
    remove_column :attendances, :votes_remaining
  end
end
