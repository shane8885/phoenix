class Event < ActiveRecord::Base
    attr_accessible :name, :public, :maxmovies, :start
    
    belongs_to :user
    
    validates :name, :presence => true, :length => { :maximum => 30 }
    validates :maxmovies, :numericality => { :within => 1..1000 }
    validates :start, :presence => true
    validates :user_id, :presence => true
end
