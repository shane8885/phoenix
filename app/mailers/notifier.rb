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
end
