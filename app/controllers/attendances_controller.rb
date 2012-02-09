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
    
    if attendance.save
      Notifier.invite_email(attendance).deliver
      redirect_to(event, :notice => 'Invitation was successfully created.')
    else
      flash[:error] = 'Sorry, Could not create invitation.'
      redirect_to(event)
    end
  end
  
  def edit
    @attendance = Attendance.find(params[:id])
    
    unless current_user.authorized?(@attendance.event.user_id)  
      action_not_permitted
    end
  end
  
  def update
    @attendance = Attendance.find(params[:id])
    
    if current_user.authorized?(@attendance.event.user_id)  
      if @attendance.update_attributes(params[:attendance])  
        redirect_to @attendance.event,:notice => 'Successfully updated attendance.'
      else
        flash[:error] = 'Sorry, could not update attendance.'
        redirect_to @attendance.event
      end
    else
      action_not_permitted
    end
  end
  
  # PUT /attendances/1/accept
  def accept
    attendance = Attendance.find(params[:id])
    if current_user.authorized?(attendance.attending_id)
      attendance.update_attribute(:confirmed, true)
      redirect_to(User.find(attendance.attending_id), :notice => 'Attendance was successfully updated.')
    else
      action_not_permitted
    end
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
  
  def show
    @attendance = Attendance.find(params[:id])
    if current_user.authorized?(@attendance.attending_id) or current_user.invited_to?(@attendance.event)
      @selections = Selection.where(:user_id => @attendance.attending_id,:event_id => @attendance.event_id)
      @votes = []
      @attendance.attending.votes.each do |v|
        if @attendance.event.selections.include?(v.selection)
          @votes << v.selection
        end
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
