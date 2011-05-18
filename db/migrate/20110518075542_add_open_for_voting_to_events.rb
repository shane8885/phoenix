class AddOpenForVotingToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :open_for_voting, :boolean, :default => true
  end

  def self.down
    remove_column :events, :open_for_voting
  end
end
