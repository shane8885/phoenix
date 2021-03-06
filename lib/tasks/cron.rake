task :cron => :environment do
  #weekly update
  if Time.now.utc.wday == 1
    Event.all.each do |e|
      #if there's been recent selections or reviews or there's movie sessions coming up in the next week
      if( e.selections.where('created_at > ?',Time.now.utc - 1.week).length > 0 or e.movie_sessions.where('start > ? and start < ?',Time.now.utc,Time.now.utc + 1.week).length > 0 or e.reviews.where('reviews.created_at > ?',Time.now.utc - 1.week).length > 0 ) 
        e.all_attendees.each do |u|
          if u.allow_notifications
            Notifier.weekly_update(u,e).deliver
          end
        end
      end
    end
  end

  #daily updates
  Event.all.each do |e|
    if( e.event_comments.where('created_at > ?',Time.now.utc-1.day).length > 0 )
      e.all_attendees.each do |u|
        if u.allow_notifications
          Notifier.daily_update(u,e).deliver
        end
      end
    end
  end

  #update event flags
  Event.all.each do |e|
    if e.selections_deadline < DateTime.now.utc and e.open_for_selections
      e.update_attribute(:open_for_selections,false)
      e.all_attendees.each do |u|
        if u.allow_notifications
          Notifier.selections_closed(u,e).deliver
        end
      end
    end
    if e.votes_deadline < DateTime.now.utc and e.open_for_voting
      e.update_attribute(:open_for_voting,false)
      e.all_attendees.each do |u|
        if u.allow_notifications
          Notifier.voting_closed(u,e).deliver
        end
      end
    end
  end
end
