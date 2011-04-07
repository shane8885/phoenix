class Attendance < ActiveRecord::Base
  belongs_to :attending, :class_name => 'User', :foreign_key => :attending_id
  belongs_to :inviting, :class_name => 'User', :foreign_key => :inviting_id
  belongs_to :event
  
  scope :coming, where(:confirmed => true)
  scope :notconfirmed, where(:confirmed => false)
end
