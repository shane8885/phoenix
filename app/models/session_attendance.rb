class SessionAttendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie_session
  
end
