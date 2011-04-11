class AddPosterToSelection < ActiveRecord::Migration
  def self.up
    add_column :selections, :poster, :string
  end

  def self.down
    remove_column :selections, :poster
  end
end
