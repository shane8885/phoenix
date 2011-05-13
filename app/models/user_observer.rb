class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Thread.new{Notifier.welcome_email(user).deliver}
  end
end
