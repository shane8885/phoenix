class SelectionsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create,:destroy]

  # POST /selections
  # POST /selections.xml
  def create
    selection = Selection.new(params[:selection])
    event = Event.find(selection.event_id)
    
    if( event.open_for_selections? )
      attendance = Attendance.find_by_event_id_and_attending_id(event.id,current_user.id)
      attendance.selections_remaining -= 1
    
      respond_to do |format|
        # this will fail if selections_remaining has gone below 0
        if attendance.save
          if selection.save
            flash[:notice] = 'Selection was successfully created.'
          else
            flash[:error] = 'Failed to create selection.'
          end
        else
          flash[:error] = 'You have no selections remaining.'
        end
        format.html { redirect_to event }
      end
    else
      flash[:error] = 'Event not open for selections.'
      redirect_to root_path
    end
  end
  
  def vote
    selection = Selection.find(params[:id])
    event = Event.find(selection.event_id)
    if current_user.invited_to?(event)
      attendance = Attendance.find_by_event_id_and_attending_id(event.id,current_user.id)
      # this will fail if votes_remaining has gone below 0
      if attendance.update_attribute(:votes_remaining, attendance.votes_remaining-1)
        selection.update_attribute(:votes, selection.votes+1)
        redirect_to(selections_event_path(event), :notice => 'Successfully updated selection.')
      else
        flash[:error] = 'Sorry, you used all your votes for this event.'
      end
    else
      redirect_to(root_path)
    end
  end

  # DELETE /selections/1
  # DELETE /selections/1.xml
  def destroy
    selection = Selection.find(params[:id])
    event = selection.event
    selection.destroy

    respond_to do |format|
      format.html { redirect_to(event, :notice => 'Successfully removed selection.') }
      format.xml  { head :ok }
    end
  end
    
end
