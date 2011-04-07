class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable, :confirmable,
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
  
  has_many :events, :dependent => :destroy
  has_many :selections
  
  has_many :open_invitations, :class_name => 'Attendance', :foreign_key => :attending_id, :conditions => {:confirmed => false}
  has_many :accepted_invitations, :class_name => 'Attendance', :foreign_key => :attending_id, :conditions => {:confirmed => true}
  has_many :accepted_events, :class_name => 'Event', :through => :accepted_invitations, :source => :event
  has_many :open_events, :class_name => 'Event', :through => :open_invitations, :source => :event
  
  has_many :sentinvitations, :class_name => 'Attendance', :foreign_key => :inviting_id
  has_many :invitees, :class_name => 'User', :through => :sentinvitations, :source => :attending
  
end
