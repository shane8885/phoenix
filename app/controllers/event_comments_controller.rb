class EventCommentsController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    comment = current_user.event_comments.build(params[:event_comment])
    event = Event.find(comment.event_id)
    if comment.save
      redirect_to(event, :notice => 'Successfully created comment.')
    end
  end
end
