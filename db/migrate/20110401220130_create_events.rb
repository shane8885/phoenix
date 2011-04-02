class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.integer :user_id
      t.boolean :public, :default => false
      t.date :start
      t.integer :maxmovies

      t.timestamps
    end
    add_index :events, :user_id
  end

  def self.down
    drop_table :events
  end
end
