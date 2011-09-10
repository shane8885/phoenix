class MovieSession < ActiveRecord::Base
  has_event_calendar :start_at_field  => 'start', :end_at_field => 'end'
  attr_accessible :event_id, :selection_id, :start, :end, :venue
  
  default_scope :order => 'movie_sessions.start'
  
  belongs_to :selection
  belongs_to :event
  
  validates :event_id, :presence => true
  validates :selection_id, :presence => true 
  validates :start, :presence => true
  validates :venue, :presence => true
end
