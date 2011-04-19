class Attendance < ActiveRecord::Base
  belongs_to :attending, :class_name => 'User', :foreign_key => :attending_id
  belongs_to :inviting, :class_name => 'User', :foreign_key => :inviting_id
  belongs_to :event
  
  validates :selections_remaining, :numericality => { :greater_than_or_equal_to => 0 }
  validates :votes_remaining, :numericality => { :greater_than_or_equal_to => 0 }
    
  scope :coming, where(:confirmed => true)
  scope :notconfirmed, where(:confirmed => false)
end
