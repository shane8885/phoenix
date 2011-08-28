class Review < ActiveRecord::Base
  attr_accessible :rating, :summary, :review, :user_id,:selection_id
  
  belongs_to :user
  belongs_to :selection
  
  validates_uniqueness_of :selection_id, :scope => :user_id
  validates :rating, :presence => true, :numericality => { :within => 1..10 }
  validates :selection_id,:presence => true
  validates :user_id, :presence => true
  validates :summary, :length => { :maximum => 55 }
  validates :review, :length => { :maximum => 2000 }
  
end
