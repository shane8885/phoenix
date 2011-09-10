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
  
  # PUT /events/1
  # PUT /events/1.xml
  def update
    @session = MovieSession.find(params[:id])
    event = Event.find(@session.event_id)
    @session.attributes = params[:movie_session]
    @session.end_at = @session.start + @session.selection.running_time.minutes
    respond_to do |format|
      if @session.save
        format.html { redirect_to(schedule_event_path(event), :notice => 'Session was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @session.errors, :status => :unprocessable_entity }
      end
    end
  end
end
