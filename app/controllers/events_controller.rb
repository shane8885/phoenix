class EventsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  # GET /events
  # GET /events.xml
  def index
    @events = Event.all
  end
  
  def search
    if( params[:search])
      @events = Event.find(:all, :conditions => { :name => params[:search] }).paginate(:page => params[:page], :per_page => 20)
    else
      @events = Event.all.paginate(:page => params[:page], :per_page => 20)
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    @title = @event.name
    @recent_selections = @event.recent_selections.limit(12)
    @comments = @event.event_comments.limit(10)
    @newcomment = EventComment.new
    
    # check that current user owns this event or that current user is admin
    if not current_user.authorized?(@event.user_id) and not current_user.invited_to?(@event)
      action_not_permitted
    end 
  end
  
  def comments
    @event = Event.find(params[:id])
    @title = @event.name
    @comments = @event.event_comments
    @newcomment = EventComment.new
    if not current_user.authorized?(@event.user_id) and not current_user.invited_to?(@event)
      action_not_permitted
    end 
  end

  def selections
    @event = Event.find(params[:id])
    @title = @event.name
    @vote = Vote.new
    @official = @event.official_selections
    @unofficial = @event.unofficial_selections
    
    # check that current user owns this event or that current user is admin
    if not current_user.authorized?(@event.user_id) and not current_user.invited_to?(@event)
      action_not_permitted
    end
  end
  
  def attendees
    @event = Event.find(params[:id])
    @title = @event.name
    # check that current user owns this event or that current user is admin
    if not current_user.authorized?(@event.user_id) and not current_user.invited_to?(@event)
      action_not_permitted
    end
  end
  
  def schedule
    @event = Event.find(params[:id])
    @title = @event.name
    @sessions = @event.movie_sessions
    
    # check that current user owns this event or that current user is admin
    if not current_user.authorized?(@event.user_id) and not current_user.invited_to?(@event)
      action_not_permitted
    end
  end
  
  def calendar
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @event = Event.find(params[:id])
    @title = @event.name
    @shown_month = Date.civil(@year, @month)

    @event_strips = MovieSession.event_strips_for_month(@shown_month, :conditions => "event_id = #{@event.id}")
    # only admin, owner or attendees can view this
    if not current_user.authorized?(@event.user_id) and not current_user.invited_to?(@event)
      action_not_permitted
    end
  end
  
  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @title = @event.name
    if not current_user.authorized?(@event.user_id)
      action_not_permitted
    end
  end

  # POST /events
  # POST /events.xml
  def create
    @event = current_user.events.build(params[:event])
    
    if @event.save
      attendance = Attendance.create!( :event_id => @event.id, :inviting_id => current_user.id, :attending_id => current_user.id, :votes_remaining => @event.votes_per_attendee, :selections_remaining => @event.selections_per_attendee )
      redirect_to(@event, :notice => 'Event was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    if @event.update_attributes(params[:event])
      redirect_to(@event, :notice => 'Event was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    if current_user.authorized?(@event.user_id)
      @event.destroy
      redirect_to events_path
    else
      action_not_permitted
    end 
  end
  
  def order_selections
    @event = Event.find(params[:id])
    @title = @event.name
    @selections = @event.official_selections.sort_by &:position
  end
  
  def schedule_parameters
    @event = Event.find(params[:id])
    @title = @event.name
  end
  
  def build_schedule
    @event = Event.find(params[:id])
    @title = @event.name
    date = @event.start
    count = 0
    mpw = params[:mpw].to_i
    time = DateTime.civil(params[:date][:year].to_i,params[:date][:month].to_i,params[:date][:day].to_i,params[:date][:hour].to_i,params[:date][:minute].to_i)
    tmptime = time
    # clear all session data for this event first
    MovieSession.delete_all(['event_id = ?',@event.id])
    selections = @event.official_selections.sort_by &:position
    selections.each do |s|
      runningtime = s.running_time ? s.running_time : 120
      session = @event.movie_sessions.build(:selection_id => s.id, :start => time, :end_at => (time + runningtime.minutes) )
      session.save
      count = count + 1
      if( count == mpw )
        time = tmptime + 1.week
        tmptime = time
        count = 0
      else
        time = time + runningtime.minutes + 15.minutes
      end
    end
    @sessions = @event.movie_sessions
    render 'schedule'
  end
  
  def update_attendees
    event = Event.find(params[:id])
    if not event.movie_sessions.where('start > ?',Time.now.utc).empty?
      event.all_attendees.each do |u|
        Notifier.schedule_update(u,event).deliver
      end
      redirect_to schedule_event_path,:notice => 'Successfully sent schedule update to event attendees.'
    else
      redirect_to schedule_event_path,:alert => 'Update was not sent, you have no upcoming sessions.'
    end
  end
  
  def new_broadcast
    @event = Event.find(params[:id])
    if not current_user.authorized?(@event.user_id)
      action_not_permitted
    end
  end
  
  def broadcast_message
    event = Event.find(params[:id])
    msg_text = params[:msg_text]
    if current_user.authorized?(event.user_id)
      event.all_attendees.each do |u|
        Notifier.send_message(u,event,msg_text).deliver
      end
      redirect_to attendees_event_path,:notice => 'Successfully sent message to attendees.'
    else
      action_not_permitted
    end
  end
  
  def voting
    @event = Event.find(params[:id])
    @title = @event.name
    @votes = []
    @event.selections.each do |s|
      s.registered_votes.each do |v|
        @votes << v
      end
    end  
    if not @votes.empty?
      @votes.sort! { |a,b| b.created_at <=> a.created_at }
    end
  end
  
  private 
    
    def action_not_permitted
      redirect_to(root_path, :alert => 'Not authorized to perform that action.')
    end
end
