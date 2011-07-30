class Selection < ActiveRecord::Base
    belongs_to :user
    belongs_to :event
    # couldn't call this 'votes' because it conflicts with column name
    has_many :registered_votes, :class_name => "Vote", :foreign_key => "selection_id"
    
    validates :event_id, :presence => true
    validates :user_id, :presence => true
    validates :movie_id, :presence => true
end
