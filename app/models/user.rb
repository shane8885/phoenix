class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable, :confirmable,
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable
 
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :avatar
  has_attached_file :avatar, :styles => { :thumb => "40x40#", :small => "150x150>", :medium => "300x300>" }, :storage => :s3, :s3_credentials => "#{::Rails.root.to_s}/config/amazon_s3.yml",
    :path => "user/:attachment/:style/:id.:extension"
  
  has_many :events, :dependent => :destroy
  has_many :selections, :dependent => :destroy
  has_many :event_comments, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  
  # relationships with Attendance model
  has_many :all_invitations, :class_name => 'Attendance', :foreign_key => :attending_id, :dependent => :destroy
  has_many :open_invitations, :class_name => 'Attendance', :foreign_key => :attending_id, :conditions => {:confirmed => false}
  has_many :accepted_invitations, :class_name => 'Attendance', :foreign_key => :attending_id, :conditions => {:confirmed => true}
  has_many :sentinvitations, :class_name => 'Attendance', :foreign_key => :inviting_id
  
  # relationships with Event model (through attendances)
  has_many :all_events, :class_name => 'Event', :through => :all_invitations, :source => :event
  has_many :open_selection_events, :class_name => 'Event', :through => :all_invitations, :source => :event, :conditions => {:open_for_selections => true}
  has_many :accepted_invitation_events, :class_name => 'Event', :through => :accepted_invitations, :source => :event
  has_many :open_invitation_events, :class_name => 'Event', :through => :open_invitations, :source => :event
  
  # relationships with other users
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
