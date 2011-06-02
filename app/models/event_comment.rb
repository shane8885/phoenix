class EventComment < ActiveRecord::Base
  default_scope :order => 'event_comments.created_at DESC'
  
  belongs_to :event
  belongs_to :user
end
