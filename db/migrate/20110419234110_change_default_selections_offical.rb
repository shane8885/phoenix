class ChangeDefaultSelectionsOffical < ActiveRecord::Migration
  def self.up
      change_column_default(:selections,:official,false)
  end

  def self.down
      change_column_default(:selections,:official,nil)
  end
end
