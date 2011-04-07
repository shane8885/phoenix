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
  admin = User.create!(:email => "admin@localhost.com",
               :password => "foobar",
               :password_confirmation => "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    email = "user-#{n+1}@localhost.com"
    password = "password"
    User.create(:email => email,
                :password => password,
                :password_confirmation => password)
  end
end

def make_events
  n = 1
  User.all(:limit => 10).each do |user|
    user.events.create(:name => "event-#{n}", :start => Date.today,:maxmovies => 100)
    n = n+1
  end
end

def make_selections
  events = Event.all
    
end

def make_acceptances
  
end
