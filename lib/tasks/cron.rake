task :cron => :environment do
  #only run on sunday
  if Time.now.wday == 0
    Event.all.each do |e|
      if( e.selections.where('created_at > ?',1.week.ago).length > 0 or e.sessions.where('start < ?',1.week.from_now).length > 0 ) 
        e.confirmed_attendees.each do |u|
          Notifier.weekly_update(u,e).deliver
        end
      end
    end
  end
end
