class AddEndToMovieSessions < ActiveRecord::Migration
  def self.up
    add_column :movie_sessions, :end, :datetime
  end

  def self.down
    remove_column :movie_sessions, :end
  end
end
