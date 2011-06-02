class CreateEventComments < ActiveRecord::Migration
  def self.up
    create_table :event_comments do |t|
      t.integer :user_id
      t.integer :event_id
      t.string :comment
      t.integer :parent_id

      t.timestamps
    end
  end

  def self.down
    drop_table :event_comments
  end
end
