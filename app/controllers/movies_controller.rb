require 'will_paginate/array'

class MoviesController < ApplicationController
    
    def search
    end
    
    def show
        @cast = []
        begin
          @movie = Tmdb::Movie.detail(params[:id])
          @trailers = Tmdb::Movie.trailers(params[:id])
        rescue
          render 'shared/tmdb_error'
        end

        if( user_signed_in? )
          @selection = current_user.selections.build()
          #user just sees their events
          @events = current_user.open_selection_events
        end
        
        if( @movie.class == Array and @movie.length == 0 )
          flash[:error] = 'Sorry, Could not find movie, this was unexpected'
          redirect_to(root_path)
        else
          @cast = Tmdb::Movie.casts(params[:id])
        end
    end

    def credits
        @cast = []
        begin
          @movie = Tmdb::Movie.detail(params[:id])
          @trailers = Tmdb::Movie.trailers(params[:id])
        rescue
          render 'shared/tmdb_error'
        end

        if( user_signed_in? )
          @selection = current_user.selections.build()
          #user just sees their events
          @events = current_user.open_selection_events
        end
        
        if( @movie.class == Array and @movie.length == 0 )
          flash[:error] = 'Sorry, Could not find movie, this was unexpected'
          redirect_to(root_path)
        else
          @cast = Tmdb::Movie.casts(params[:id])
        end
    end
    
    def index
        begin
          results = Tmdb::Movie.find(params[:search])
        rescue
          render 'shared/tmdb_error'
        end
        # if only one result is returned it doesn't come back in an array, annoying. So we have to do this
        if( results.class == Array)
           @movies = results.paginate(:page => params[:page], :per_page => 10)
        else
           @movies = Array.new(1,results).paginate(:page => params[:page], :per_page => 10)
        end
    end
end
