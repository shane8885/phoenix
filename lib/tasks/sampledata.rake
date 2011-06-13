require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_events
    make_selections
    make_attendances
    make_sessions
    make_comments
  end
end

def make_users
  ActionMailer::Base.perform_deliveries = false
  admin = User.create!(:username => "admin",
               :email => "admin@localhost.com",
               :password => "foobar",
               :password_confirmation => "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    user = "user-#{n+1}"
    email = "#{user}@localhost.com"
    password = "password"
    User.create(:username => user,
                :email => email,
                :password => password,
                :password_confirmation => password)
  end
  ActionMailer::Base.perform_deliveries = true
end

def make_events
  10.times do |n|
    user = User.find(n+1)
    user.events.create(:name => Faker::Lorem.words(1)[0], :start => 60.days.from_now,:selections_deadline => 30.days.from_now,:votes_deadline => 50.days.from_now,:maxmovies => 100,:description => Faker::Lorem.paragraph(1+rand(10)))
  end
end

def make_selections
  Event.all.each do |event|
    rand(50).times do
      official = false
      if rand(2) == 0
        official = true
      end
      movie = rand(10000)
      running_time = rand(180)
      Selection.create(:event_id => event.id, :movie_id => movie,:movie_name => "#{movie}",:votes => rand(50),:official => official,:user_id => rand(100),:poster => 'no_poster.jpg', :running_time => running_time )
    end
  end 
end

def make_attendances
  Event.all.each do |event|
    rand(50).times do
      confirmed = false
      if rand(2) == 0
        confirmed = true
      end
      Attendance.create(:attending_id => rand(99)+1,:inviting_id => rand(99)+1,:event_id => event.id,:selector => true,:confirmed => confirmed, :selections_remaining => event.selections_per_attendee, :votes_remaining => event.votes_per_attendee )
    end
  end
end

def make_sessions
  Event.all.each do |event|
    Selection.find_all_by_event_id(event.id).each do |selection|
      Session.create!( :event_id => event.id, :selection_id => selection.id, :start => rand(100).days.from_now + rand(100).minutes )
    end
  end
end

def make_comments
  Event.all.each do |event|
    rand(10).times do
      user = User.find(rand(99)+1)
      EventComment.create!( :event_id => event.id, :user_id => user.id, :comment => Faker::Lorem.paragraph(1 + rand(15)))
    end
  end
end
