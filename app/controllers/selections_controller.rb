class SelectionsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create,:destroy,:vote]

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
      attendance.votes_remaining -= 1
      # this will fail if votes_remaining has gone below 0
      if attendance.save
        if selection.update_attribute(:votes, selection.votes+1)
          redirect_to(selections_event_path(event), :notice => "Successfully registered vote.")
        else
          flash[:error] = 'Sorry, something went wrong in registering your vote.'
          redirect_to selections_event_path(event)
        end
      else
        flash[:error] = 'Sorry, you used all your votes for this event.'
        redirect_to selections_event_path(event)
      end
    else
      redirect_to(root_path)
    end
  end

  # PUT /selections/1/promote
  def promote
    selection = Selection.find(params[:id])
    event = Event.find(selection.event_id)
    if current_user.authorized?(event.user_id)
      if selection.update_attribute(:official, true)
        redirect_to(selections_event_path(event), :notice => 'Successfully promoted selection.')
      else
        flash[:error] = 'Sorry, something went wrong while updating this selection.'
        redirect_to(selections_event_path(event))
      end
    else
      redirect_to(root_path)
    end
  end
  
  # PUT /selections/1/demote
  def demote
    selection = Selection.find(params[:id])
    event = Event.find(selection.event_id)
    if current_user.authorized?(event.user_id)
      if selection.update_attribute(:official, false)
        redirect_to(selections_event_path(event), :notice => 'Successfully demoted selection.')
      else
        flash[:error] = 'Sorry, something went wrong while updating this selection.'
        redirect_to(selections_event_path(event))
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
  
  def sort
    params[:selections].each_with_index do |id,index|
      Selection.update_all(['position=?',index+1],['id=?',id])
    end
    render :nothing => true
  end
end
