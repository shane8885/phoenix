namespace :db do
  desc "Convert all sessions to calendar events"
  task :session_end => :environment do
    MovieSession.all.each do |s|
      s.end = s.start + s.selection.running_time.minutes
      s.save
    end    
  end
end

