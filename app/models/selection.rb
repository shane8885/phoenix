class Selection < ActiveRecord::Base
    belongs_to :user
    belongs_to :event
    has_one :movie_session
    
    # couldn't call this 'votes' because it conflicts with column name
    has_many :registered_votes, :class_name => "Vote", :foreign_key => "selection_id", :dependent => :destroy
    has_many :reviews, :dependent => :destroy
    has_many :reviewers, :class_name => 'User', :through => :reviews, :source => :user
    
    validates_uniqueness_of :movie_id, :scope => :event_id
    validates :event_id, :presence => true
    validates :user_id, :presence => true
    validates :movie_id, :presence => true
    
    def average_rating
      if self.reviews.size > 0
        rating = 0
        self.reviews.each do |review|
            rating = rating + review.rating
        end
        total = self.reviews.size
        avg = rating.to_f / total.to_f
        avg.round(1)
      else
        0
      end
    end
end
