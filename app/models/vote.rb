class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :selection
  
  validates :selection_id, :presence => true
  validates :user_id, :presence => true
end
