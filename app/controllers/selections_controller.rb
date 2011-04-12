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

    respond_to do |format|
      if selection.update_attributes(params[:selection])
        format.html { redirect_to(Event.find(selection.event_id), :notice => 'Selection was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { redirect_to root_path }
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
