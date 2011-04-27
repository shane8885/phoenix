namespace :db do
  desc "Reset the DB and create the admin user"
  task :initialise => :environment do
    Rake::Task['db:reset'].invoke
    make_admin
  end
end

def make_admin
  admin = User.create!(:username => "admin",
               :email => "admin@localhost.com",
               :password => "gr33nb3r3t",
               :password_confirmation => "gr33nb3r3t")
  admin.toggle!(:admin)
end

