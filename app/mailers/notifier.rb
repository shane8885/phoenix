class Notifier < ActionMailer::Base
  default :from => "garagefilmfestival@gmx.com"
  
  def welcome_email(user)
    @user = user
    @url  = "http://localhost:3000/login"
    mail(:to => user.email,
         :subject => "Welcome to GarageFilmFestivals")
  end
  
  def invite_email(invite)
    @inviter = User.find(invite.inviting_id)
    @attendee = User.find(invite.attending_id)
    @event = Event.find(invite.event_id)
    mail(:to => @attendee.email, 
         :subject => "Invite to #{@event.name}") 
  end
  
  def weekly_update(user,event)
    @user = user
    @event = event
    @sessions = @event.movie_sessions.where('start > ? and start < ?',Time.now.utc,Time.now.utc + 1.week)
    @selections = @event.selections.where('created_at > ?',Time.now.utc - 1.week)
    @reviews = @event.reviews.where('reviews.created_at > ?', Time.now.utc - 1.week)
    mail(:to => @user.email, 
         :subject => "Update for #{@event.name}")
  end

  def daily_update(user,event)
    @user = user
    @event = event
    @comments = @event.event_comments.where('created_at > ?',Time.now.utc-1.day)
    mail(:to => @user.email,
         :subject => "#{@event.name} - New comments" )
  end

  def schedule_update(user,event)
    @event = event
    @user = user
    @sessions = @event.movie_sessions.where('start > ?',Time.now.utc)
    mail(:to => @user.email,
         :subject => "Schedule Update")
  end
  
  def selections_closed(user,event)
    @event = event
    @user = user
    mail(:to => @user.email,
         :subject => "Selections Closed")
  end
  
  def voting_closed(user,event)
    @event = event
    @user = user
    @votecount = 0
    @event.selections.each do |s|
      @votecount += s.votes
    end
    mail(:to => @user.email,
         :subject => "Voting Closed")
  end
  
  def send_message(user,event,msg_text)
    @event = event
    @user = user
    @msg_text = msg_text
    mail(:to => @user.email,
         :subject => "Message from #{@event.name}")
  end
end
