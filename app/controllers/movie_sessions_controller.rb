class MovieSessionsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /events/1/edit
  def edit
    @session = MovieSession.find(params[:id])
    @event = Event.find(@session.event_id)
    @selection = Selection.find(@session.selection_id)
    #only the event owner can modify sessions, or admin
    if not current_user.authorized?(@event.user_id)
      action_not_permitted
    end
  end
  
  def show
    @session = MovieSession.find(params[:id])
    @session_attendance = SessionAttendance.find_by_user_id_and_movie_session_id(current_user.id,@session.id)
    @new_attendance = SessionAttendance.new
    unless current_user.authorized?(@session.selection.user_id) or current_user.invited_to?(@session.selection.event)
      action_not_permitted
    end
  end
  # PUT /events/1
  # PUT /events/1.xml
  def update
    @session = MovieSession.find(params[:id])
    event = Event.find(@session.event_id)
    @session.attributes = params[:movie_session]
    runningtime = @session.selection.running_time ? @session.selection.running_time : 120
    @session.end_at = @session.start + runningtime.minutes

    if @session.save
      redirect_to(@session, :notice => 'Session was successfully updated.')
    else
      render :action => "edit"
    end

  end
  
  def destroy
    session = MovieSession.find(params[:id])
    event = session.event
    if current_user.authorized?(event.user_id)
      session.destroy
      redirect_to(schedule_event_path(event), :notice => 'Successfully removed selection.')
    else
      action_not_permitted
    end
  end
  
  private 
    
    def action_not_permitted
      redirect_to(root_path, :alert => 'Not authorized to perform that action.')
    end
end
