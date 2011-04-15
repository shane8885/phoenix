class SelectionsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create,:destroy]

  # POST /selections
  # POST /selections.xml
  def create
    selection = Selection.new(params[:selection])

    respond_to do |format|
      if selection.save
        flash[:notice] = 'Selection was successfully created.'
        format.html { redirect_to(:controller => 'movies', :action => 'show', :id => selection.movie_id ) }
      else
          #TODO: this is an error, new action doesn't exist
        format.html { redirect_to root_path }
      end
    end
  end

  # PUT /selections/1
  # PUT /selections/1.xml
  def update
    selection = Selection.find(params[:id])
    event = Event.find(selection.event_id)
    voting_ok = true
    # if this update represents a vote we have to decrement the users vote allowance
    # also, if they run out of votes we have to return an error
    if params[:voting]
      attendance = Attendance.find_by_event_id_and_attending_id(selection.event_id,current_user.id)
      if attendance.votes_remaining > 0
        attendance.votes_remaining -= 1
        if not attendance.save
          flash[:error] = 'Failed to updated attendance.'
          voting_ok = false
        end
      else
        flash[:error] = 'You have no more votes.'
        voting_ok = false
      end
    end
    
    respond_to do |format|
      if voting_ok and selection.update_attributes(params[:selection] )
        format.html { redirect_to(event, :notice => 'Successfully updated selection.') }
        format.xml  { head :ok }
      else
        format.html { redirect_to event }
      end
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
