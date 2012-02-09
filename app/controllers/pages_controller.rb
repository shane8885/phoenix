class PagesController < ApplicationController
  Tmdb.api_key = "9027009be089788945e1c7aa516338a2"
  
  def home
      @title = "Home"
      # don't bother doint this query on mobile platforms, the view doen't use it
      if not request.format == :mobile
        # the tmdb browse interface has traffic limits so we need to be handle potential 503 errors
        begin
            @recent_movies = TmdbMovie.browse(:order_by => "release",:order => "desc", :release_min => 1.year.ago.to_i,:release_max => Time.now.to_i, :page => 1, :per_page => 10, :language => "en", :certifications => "G,PG,PG-13,R", :countries => "au,us,gb", :expand_results => false)
            @suggested_movie = TmdbMovie.browse(:order_by => "rating", :order => "desc", :min_votes => 3, :page => rand(30), :per_page => 10, :language => "en", :certifications => "G,PG,PG-13,R", :expand_results => false)[rand(10)]
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
