class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  before_filter :app_setup
  Tmdb::Api.key("9027009be089788945e1c7aa516338a2")

  private

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end
  helper_method :mobile_device?

  def app_setup
    @tmdb = Tmdb::Configuration.new
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end

end
