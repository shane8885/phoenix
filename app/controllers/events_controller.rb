class EventsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  # GET /events
  # GET /events.xml
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    @official = @event.official_selections.paginate(:page => params[:official_page],:per_page => 10)
    @unofficial = @event.unofficial_selections.paginate(:page => params[:unofficial_page],:per_page => 10)
    @comments = @event.event_comments
    @newcomment = EventComment.new
    
    # check that current user owns this event or that current user is admin
    if not current_user.authorized?(@event.user_id) and not current_user.invited_to?(@event)
      action_not_permitted
    end 
  end

  def selections
    @event = Event.find(params[:id])
    @official = @event.official_selections.paginate(:page => params[:official_page],:per_page => 10)
    @unofficial = @event.unofficial_selections.paginate(:page => params[:unofficial_page],:per_page => 10)
    
    # check that current user owns this event or that current user is admin
    if not current_user.authorized?(@event.user_id) and not current_user.invited_to?(@event)
      action_not_permitted
    end
  end
  
  def attendees
    @event = Event.find(params[:id])
    
    # check that current user owns this event or that current user is admin
    if not current_user.authorized?(@event.user_id) and not current_user.invited_to?(@event)
      action_not_permitted
    end
  end
  
  def schedule
    @event = Event.find(params[:id])
    @sessions = @event.sessions
    
    # check that current user owns this event or that current user is admin
    if not current_user.authorized?(@event.user_id) and not current_user.invited_to?(@event)
      action_not_permitted
    end
  end
  
  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    if not current_user.authorized?(@event.user_id)
      action_not_permitted
    end
  end

  # POST /events
  # POST /events.xml
  def create
    @event = current_user.events.build(params[:event])
    
    respond_to do |format|
      if @event.save
        attendance = Attendance.create!( :event_id => @event.id, :inviting_id => current_user.id, :attending_id => current_user.id, :votes_remaining => @event.votes_per_attendee, :selections_remaining => @event.selections_per_attendee )
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    if current_user.authorized?(@event.user_id)
      @event.destroy
    else
      action_not_permitted
    end 
  end
  
  private 
    
    def action_not_permitted
      redirect_to(root_path, :notice => 'Not authorized to perform that action.')
    end
end
