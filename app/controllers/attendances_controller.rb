class AttendancesController < ApplicationController
  before_filter :authenticate_user!

  # POST /attendances
  # POST /attendances.xml
  def create
    attendance = Attendance.new(params[:attendance])
    event = Event.find(attendance.event_id)
    #fill out the vote and selection allowances for attendees
    attendance.votes_remaining = event.votes_per_attendee
    attendance.selections_remaining = event.selections_per_attendee
    
    respond_to do |format|
      if attendance.save
        Notifier.invite_email(attendance).deliver
        format.html { redirect_to(event, :notice => 'Invitation was successfully created.') }
      else
        format.html { redirect_to(event, :notice => 'Could not create invitation.') }
      end
    end
  end
  
  # PUT /attendances/1/accept
  def accept
    attendance = Attendance.find(params[:id])
    attendance.update_attribute(:confirmed, true)
    redirect_to(current_user, :notice => 'Attendance was successfully updated.')
  end
  
  # DELETE /attendances/1
  # DELETE /attendances/1.xml
  def destroy
    attendance = Attendance.find(params[:id])
    if( current_user.authorized?(attendance.attending_id) or current_user.authorized?(attendance.inviting_id) )
      attendance.destroy
      respond_to do |format|
        format.html { redirect_to(current_user, :notice => 'Successfully destroyed invitation or attendee') }
        format.xml  { head :ok }
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
