class RenameColumnInMovieSessions < ActiveRecord::Migration
  def self.up
    rename_column :movie_sessions, :end, :end_at
  end

  def self.down
    rename_column :movie_sessions, :end_at, :end
  end
end
