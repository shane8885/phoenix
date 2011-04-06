class CreateSelections < ActiveRecord::Migration
  def self.up
    create_table :selections do |t|
      t.integer :event_id
      t.integer :movie_id
      t.string  :movie_name
      t.integer :user_id
      t.integer :votes
      t.boolean :official

      t.timestamps
    end
    add_index :selections, :event_id
    add_index :selections, :user_id
  end

  def self.down
    drop_table :selections
  end
end
