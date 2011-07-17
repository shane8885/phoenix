class AddVenueToSessions < ActiveRecord::Migration
  def self.up
    add_column :sessions, :venue, :string, :default => "TBD"
  end

  def self.down
    remove_column :sessions, :venue
  end
end
