class VotesController < ApplicationController
  before_filter :authenticate_user!

  def create
    vote = Vote.new(params[:vote])
    selection = vote.selection
    event = selection.event
    
    if current_user.invited_to?(event)
      attendance = Attendance.find_by_event_id_and_attending_id(event.id,current_user.id)
      attendance.votes_remaining -= 1
      # this will fail if votes_remaining has gone below 0
      if attendance.save
        if selection.update_attribute(:votes, selection.votes+1) and vote.save
          redirect_to selection,:notice => "Successfully registered vote."
        else
          flash[:error] = 'Sorry, something went wrong while registering you vote.'
          redirect_to selections_event_path(event)
        end
      else
        flash[:error] = 'Sorry, you used all you votes.'
        redirect_to selections_event_path(event)
      end
      
    else
      redirect_to root_path
    end
  end
  
  def destroy
    vote = Vote.find(params[:id])  
    event = vote.selection.event
    if current_user.authorized?(vote.user_id)
      attendance = Attendance.find_by_event_id_and_attending_id(event.id,vote.user_id)
      # update the attendance allocation
      attendance.update_attribute(:votes_remaining,attendance.votes_remaining+1)
      # update the selectio vote count
      if vote.selection.votes > 0
        vote.selection.update_attribute(:votes,vote.selection.votes-1)
      end
      # destroy
      if vote.destroy
        redirect_to voting_event_path(event),:notice => 'Successfully removed vote'
      else
        flash[:error] = 'Sorry, something went wrong while trying to remove your vote.'
        redirect_to voting_event_path(event)
      end
    else
      action_not_permitted
    end 
  end
  
  private 
    
    def action_not_permitted
      redirect_to(root_path, :notice => 'Not authorized to perform that action.')
    end
  
end
