class Event < ActiveRecord::Base
    attr_accessible :name, :public, :maxmovies, :start
    
    belongs_to :user
    has_many :selections
    has_many :accepted_invitations, :class_name => 'Attendance', :conditions => {:confirmed => true}
    has_many :not_accepted_invitations, :class_name => 'Attendance', :conditions => {:confirmed => false}
    has_many :confirmed_attendees, :class_name => 'User', :through => :accepted_invitations, :source => :attending
    has_many :unconfirmed_attendees, :class_name => 'User', :through => :not_accepted_invitations, :source => :attending
    
    validates :name, :presence => true, :length => { :maximum => 30 }
    validates :maxmovies, :numericality => { :within => 1..1000 }
    validates :start, :presence => true
    validates :user_id, :presence => true
end
