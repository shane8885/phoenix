class Attendance < ActiveRecord::Base
  belongs_to :attending, :class_name => 'User', :foreign_key => :attending_id
  belongs_to :inviting, :class_name => 'User', :foreign_key => :inviting_id
  belongs_to :event
  
  # a user can only be invited to an event once
  validates_uniqueness_of :attending_id, :scope => :event_id
  validates :selections_remaining, :presence => true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :votes_remaining, :presence => true, :numericality => { :greater_than_or_equal_to => 0 }
    
  scope :coming, where(:confirmed => true)
  scope :notconfirmed, where(:confirmed => false)
end
