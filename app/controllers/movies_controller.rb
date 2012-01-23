class MoviesController < ApplicationController
    Tmdb.api_key = "9027009be089788945e1c7aa516338a2"
    
    def search
    end
    
    def show
        @actors = []
        @credits = []
        @movie = TmdbMovie.find(:id => params[:id], :expand_results => true, :limit => 1)

        if( user_signed_in? ):
          @selection = current_user.selections.build()
          #user just sees their events
          @events = current_user.open_selection_events
        end
        
        if( @movie.class == Array and @movie.length == 0 )
          flash[:error] = 'Sorry, Could not find movie, this was unexpected'
          redirect_to(root_path)
        else
          @actors = @movie.cast.find_all{|member| member.job == 'Actor'}
          @credits = @movie.cast.find_all{|member| member.job != 'Actor'}
        end
    end

    def credits
        @actors = []
        @credits = []
        @movie = TmdbMovie.find(:id => params[:id], :expand_results => true, :limit => 1)

        if( user_signed_in? ):
          @selection = current_user.selections.build()
          #user just sees their events
          @events = current_user.open_selection_events
        end
        
        if( @movie.class == Array and @movie.length == 0 )
          flash[:error] = 'Sorry, Could not find movie, this was unexpected'
          redirect_to(root_path)
        else
          @actors = @movie.cast.find_all{|member| member.job == 'Actor'}
          @credits = @movie.cast.find_all{|member| member.job != 'Actor'}
        end

    end
    
    def index
        results = TmdbMovie.find(:title => params[:search], :expand_results => false, :limit => 100)
        # if only one result is returned it doesn't come back in an array, annoying. So we have to do this
        if( results.class == Array)
           @movies = results.paginate(:page => params[:page], :per_page => 10)
        else
           @movies = Array.new(1,results).paginate(:page => params[:page], :per_page => 10)
        end
    end
end
