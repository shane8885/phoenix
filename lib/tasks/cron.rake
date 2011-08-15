task :cron => :environment do
  #only run on sunday
  if Time.now.utc.wday == 1
    Event.all.each do |e|
      if( e.selections.where('created_at > ?',Time.now.utc - 1.week).length > 0 or e.sessions.where('start > ? and start < ?',Time.utc.now,Time.now.utc + 1.week).length > 0 ) 
        e.confirmed_attendees.each do |u|
          if u.allow_notifications
            Notifier.weekly_update(u,e).deliver
          end
        end
      end
    end
  end
  #update event flags
  Event.all.each do |e|
    if e.selections_deadline < DateTime.now.utc and e.open_for_selections
      e.update_attribute(:open_for_selections,false)
      e.confirmed_attendees.each do |u|
        if u.allow_notifications
          Notifier.selections_closed(u,e).deliver
        end
      end
    end
    if e.votes_deadline < DateTime.now.utc and e.open_for_voting
      e.update_attribute(:open_for_voting,false)
      e.confirmed_attendees.each do |u|
        if u.allow_notifications
          Notifier.voting_closed(u,e).deliver
        end
      end
    end
  end
end
