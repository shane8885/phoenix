task :cron => :environment do
  Notifier.weekly_update(User.first)
end
