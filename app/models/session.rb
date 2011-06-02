class Session < ActiveRecord::Base
  attr_accessible :event_id, :selection_id, :start
  
  default_scope :order => 'sessions.start'
  
  belongs_to :selection
  belongs_to :event
  
  validates :event_id, :presence => true
  validates :selection_id, :presence => true 
  validates :start, :presence => true
end
