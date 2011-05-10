class Notifier < ActionMailer::Base
  default :from => "garagefilmfestival@gmx.com"
  
  def welcome_email(user)
    @user = user
    @url  = "http://localhost:3000/login"
    mail(:to => user.email,
         :subject => "Welcome to GarageFilmFestivals")
  end
end
