class SessionAttendancesController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    attendance = SessionAttendance.new(params[:session_attendance])
    
    # if the current user is invited to this event
    if current_user.invited_to?(attendance.movie_session.selection.event) or current_user.admin
      if attendance.save
        redirect_to attendance.movie_session,:notice => "Your attendance has been registered."
      else
        redirect_to attendance.movie_session, :error => "Sorry, something went wrong, your attendance was not registered."
      end
    else
      action_not_permitted
    end
  end
  
  def destroy
    attendance = SessionAttendance.find(params[:id])
    
    # if the current user owns this attendance or they're an admin
    if current_user.authorized?(attendance.user_id)
      if(attendance.destroy)
        redirect_to attendance.movie_session,:notice => "You have been removed from the attendance list."
      else
        redirect_to attendance.movie_session,:error => "Sorry, something went wrong, we could not remove your attendance."
      end
    else
      action_not_permitted
    end
  end
  
  private 
    
    def action_not_permitted
      redirect_to(root_path, :notice => 'Not authorized to perform that action.')
    end
end
