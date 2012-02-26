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
  
  private 
    
    def action_not_permitted
      redirect_to(root_path, :alert => 'Not authorized to perform that action.')
    end
end
