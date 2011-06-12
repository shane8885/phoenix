class Event < ActiveRecord::Base
attr_accessible :name, :description, :public, :maxmovies, :start, :selections_deadline, :votes_deadline, :open_for_voting, :open_for_selections, :votes_per_attendee, :selections_per_attendee, :poster
  has_attached_file :poster, :styles => { :thumb => "60x60>", :small => "150x150>", :medium => "300x300>" }
  
  belongs_to :user
  has_many :selections, :dependent => :destroy
  has_many :attendances, :dependent => :destroy
  has_many :sessions, :dependent => :destroy
  has_many :official_selections, :class_name => 'Selection', :conditions => {:official => true}
  has_many :unofficial_selections, :class_name => 'Selection', :conditions => {:official => false}
  has_many :accepted_invitations, :class_name => 'Attendance', :conditions => {:confirmed => true}
  has_many :not_accepted_invitations, :class_name => 'Attendance', :conditions => {:confirmed => false}
  has_many :confirmed_attendees, :class_name => 'User', :through => :accepted_invitations, :source => :attending
  has_many :unconfirmed_attendees, :class_name => 'User', :through => :not_accepted_invitations, :source => :attending
  has_many :event_comments
  
  validates :name, :presence => true, :length => { :maximum => 30 }
  validates :maxmovies, :presence => true, :numericality => { :within => 1..1000 }
  validates :start, :presence => true
  validates :selections_deadline, :presence => true
  validates :votes_deadline, :presence => true
  validates :user_id, :presence => true
  validates_attachment_content_type :poster, :content_type => ['image/jpeg', 'image/png']
end
