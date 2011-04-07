class CreateAttendances < ActiveRecord::Migration
  def self.up
    create_table :attendances do |t|
      t.integer :event_id
      t.integer :attending_id
      t.integer :inviting_id
      t.boolean :confirmed, :default => false
      t.boolean :selector, :default => true

      t.timestamps
    end
    add_index :attendances, :event_id
    add_index :attendances, :attending_id
  end

  def self.down
    drop_table :attendances
  end
end
