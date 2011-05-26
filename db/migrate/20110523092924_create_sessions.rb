class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.integer :event_id
      t.integer :selection_id
      t.datetime :start

      t.timestamps
    end
    add_index :sessions, :event_id
  end

  def self.down
    drop_table :sessions
  end
end
