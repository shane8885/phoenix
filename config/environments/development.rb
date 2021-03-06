require 'development_mail_interceptor'

Phoenix::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  #add an observer to respond to user model stuff
  config.active_record.observers = :user_observer

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  #config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # mail config
  config.action_mailer.default_url_options = { :host => 'localhost:3000' } 
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :tls => false,
    :enable_starttls_auto => false,
    :address => "mail.gmx.com",
    :port => 25,
    :authentication => :login,
    :user_name => "garagefilmfestival@gmx.com" ,
    :password => "festival"
  }
  #redirect emails when in dev
  Mail.register_interceptor(DevelopmentMailInterceptor)
  
  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
end

