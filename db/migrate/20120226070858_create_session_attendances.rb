class CreateSessionAttendances < ActiveRecord::Migration
  def self.up
    create_table :session_attendances do |t|
      t.integer :user_id
      t.integer :movie_session_id

      t.timestamps
    end
  end

  def self.down
    drop_table :session_attendances
  end
end
