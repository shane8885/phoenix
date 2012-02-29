class SessionAttendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie_session
  
  validates_uniqueness_of :user_id, :scope => :movie_session_id
end
