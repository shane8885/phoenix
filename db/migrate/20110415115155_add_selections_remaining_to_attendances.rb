class AddSelectionsRemainingToAttendances < ActiveRecord::Migration
  def self.up
    add_column :attendances, :selections_remaining, :integer
  end

  def self.down
    remove_column :attendances, :selections_remaining
  end
end
