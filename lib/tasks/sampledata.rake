namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_events
    make_selections
    make_acceptances
  end
end

def make_users
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
end

def make_events
  10.times do |n|
    user = User.find(n+1)
    user.events.create(:name => "event-#{n+1}", :start => Date.today,:maxmovies => 100)
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
      Selection.create(:event_id => event.id, :movie_id => movie,:movie_name => "#{movie}",:votes => rand(50),:official => official,:user_id => rand(100),:poster => 'no_poster.jpg' )
    end
  end 
end

def make_acceptances
  Event.all.each do |event|
    rand(50).times do
      confirmed = false
      if rand(2) == 0
        confirmed = true
      end
      Attendance.create(:attending_id => rand(100),:inviting_id => rand(100),:event_id => event.id,:selector => true,:confirmed => confirmed)
    end
  end
end
