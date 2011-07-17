class MovieSession < ActiveRecord::Base
  attr_accessible :event_id, :selection_id, :start, :venue
  
  default_scope :order => 'movie_sessions.start'
  
  belongs_to :selection
  belongs_to :event
  
  validates :event_id, :presence => true
  validates :selection_id, :presence => true 
  validates :start, :presence => true
  validates :venue, :presence => true
end
