class AttendancesController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /attendances
  # GET /attendances.xml
  def index
    @attendances = Attendance.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @attendances }
    end
  end

  # POST /attendances
  # POST /attendances.xml
  def create
    attendance = Attendance.new(params[:attendance])

    respond_to do |format|
      if attendance.save
        format.html { redirect_to(Event.find(attendance.event_id), :notice => 'Invitation was successfully created.') }
      else
        format.html { redirect_to root_path }
      end
    end
  end

  # PUT /attendances/1
  # PUT /attendances/1.xml
  def update
    attendance = Attendance.find(params[:id])

    respond_to do |format|
      if attendance.update_attributes(params[:attendance])
        format.html { redirect_to(current_user, :notice => 'Attendance was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => attendance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /attendances/1
  # DELETE /attendances/1.xml
  def destroy
    attendance = Attendance.find(params[:id])
    if( current_user.authorized?(attendance.attending_id) or current_user.authorized?(attendance.inviting_id) )
      attendance.destroy
    else
      action_not_permitted
    end

    respond_to do |format|
      format.html { redirect_to(current_user, :notice => 'Successfully destroyed invitation') }
      format.xml  { head :ok }
    end
  end
  
  private 
  
    def action_not_permitted
      redirect_to(root_path, :notice => 'Not authorized to perform that action.')
    end
    
end
