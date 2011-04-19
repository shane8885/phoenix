class ChangeDefaultSelectionsVotes < ActiveRecord::Migration
  def self.up
    change_column_default(:selections,:votes,0)
  end

  def self.down
    change_column_default(:selections,:votes,nil)
  end
end
