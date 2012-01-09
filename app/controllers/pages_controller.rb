class PagesController < ApplicationController
  Tmdb.api_key = "9027009be089788945e1c7aa516338a2"
  
  def home
      @title = "Home"
      @recent_movies = TmdbMovie.browse(:order_by => "release",:order => "desc", :release_min => 1.year.ago.to_i,:release_max => Time.now.to_i, :page => 1, :per_page => 10, :language => "en", :certifications => "G,PG,PG-13,R", :countries => "au,us,gb", :expand_results => false)
      @suggested_movie = TmdbMovie.browse(:order_by => "rating", :order => "desc", :min_votes => 3, :page => rand(30), :per_page => 10, :language => "en", :certifications => "G,PG,PG-13,R", :expand_results => false)[rand(10)]
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
