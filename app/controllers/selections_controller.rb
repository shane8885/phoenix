class SelectionsController < ApplicationController
  before_filter :authenticate_user!
  
  Tmdb.api_key = "9027009be089788945e1c7aa516338a2"

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
            flash[:error] = 'Failed to add selection. It may already exist.'
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

  def edit
    @selection = Selection.find(params[:id])
    
    unless current_user.authorized?(@selection.event.user_id)  
      action_not_permitted
    end
  end
  
  def update
    @selection = Selection.find(params[:id])
    
    if current_user.authorized?(@selection.event.user_id)
      if @selection.update_attributes(params[:selection])
        redirect_to @selection, :notice => 'Successfully updated selection.'
      else
        flash[:error] = "Sorry, could not update this selection."
        redirect_to @selection
      end
    else
      action_not_permitted
    end
  end
  
  def show
    @selection = Selection.find(params[:id])
    if current_user.authorized?(@selection.user_id) or current_user.invited_to?(@selection.event)
      @movie = TmdbMovie.find(:id => @selection.movie_id, :expand_results => true, :limit => 1)
      @vote = Vote.new
      
      if( @movie.class == Array and @movie.length == 0 )
        flash[:error] = 'Sorry, Could not find movie, this was unexpected'
        redirect_to(root_path)
      end
    else
      action_not_permitted
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
      action_not_permitted
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
      action_not_permitted
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
  
  private 
    
    def action_not_permitted
      redirect_to(root_path, :notice => 'Not authorized to perform that action.')
    end
    
end
