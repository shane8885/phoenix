class PagesController < ApplicationController
  def home
      @title = "Home"
      # don't bother doint this query on mobile platforms, the view doen't use it
      if not request.format == :mobile
        # the tmdb browse interface has traffic limits so we need to be handle potential 503 errors
        begin
            @recent_movies = Tmdb::Movie.now_playing
            popular = Tmdb::Movie.popular
            @suggested_movie = Tmdb::Movie.detail(popular[rand(popular.length)]['id'])
        rescue
          @recent_movies = []
          @suggested_movie = nil
          flash.now[:error] = 'We are having problems accessing the movie database, you may experience difficulties. Sorry.'
        end
      end
  end

  def contact
      @title = "Contact"
  end

  def about
      @title = "About"
  end

  def help
      @title = "About"
  end

end
