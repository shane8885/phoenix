class RenameSessions < ActiveRecord::Migration
  def self.up
    rename_table :sessions, :movie_sessions
  end

  def self.down
    rename_table :movie_sessions, :sessions
  end
end
