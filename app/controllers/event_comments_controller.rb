class EventCommentsController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    @comment = current_user.event_comments.build(params[:event_comment])
    @comment.save
    respond_to do |format|
      format.html { redirect_to(@comment.event, :notice => 'Successfully created comment.') }
      format.js
    end
  end
  
  def edit
    @comment = EventComment.find(params[:id])
    @event = Event.find(@comment.event_id)
    
    #only the event owner can modify sessions, or admin
    if not current_user.authorized?(@comment.user_id)
      action_not_permitted
    end
  end
  
  def update
    @comment = EventComment.find(params[:id])
    event = Event.find(@comment.event_id)
    
    respond_to do |format|
      if @comment.update_attributes(params[:event_comment])
        format.html { redirect_to(event, :notice => 'Comment was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  def destroy
    @comment = EventComment.find(params[:id])
    event = Event.find(@comment.event_id)
    if current_user.authorized?(@comment.user_id)
      @comment.destroy
      redirect_to event, :notice => 'Comment was successfully destroyed.'
    end
  end
  
end
