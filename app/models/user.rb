class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable, :confirmable,
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable
 
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username
  
  has_many :events
  has_many :selections
  
  has_many :all_invitations, :class_name => 'Attendance', :foreign_key => :attending_id
  has_many :open_invitations, :class_name => 'Attendance', :foreign_key => :attending_id, :conditions => {:confirmed => false}
  has_many :accepted_invitations, :class_name => 'Attendance', :foreign_key => :attending_id, :conditions => {:confirmed => true}
  has_many :all_events, :class_name => 'Event', :through => :all_invitations, :source => :event
  has_many :accepted_events, :class_name => 'Event', :through => :accepted_invitations, :source => :event
  has_many :open_events, :class_name => 'Event', :through => :open_invitations, :source => :event
  
  has_many :sentinvitations, :class_name => 'Attendance', :foreign_key => :inviting_id
  has_many :invitees, :class_name => 'User', :through => :sentinvitations, :source => :attending
  
  validates_presence_of :username
  validates_uniqueness_of :username
  
  def authorized?(id)
    self.admin? or self.id == id
  end
  
  def invited_to?(event)
    self.all_events.exists?(event.id)
  end
  
end
