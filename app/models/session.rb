class Session < ActiveRecord::Base
  attr_accessible :event_id, :selection_id, :start
  
  default_scope :order => 'sessions.start'
  
  belongs_to :selection
  belongs_to :event
end
