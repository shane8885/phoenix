class MoviesController < ApplicationController
    Tmdb.api_key = "9027009be089788945e1c7aa516338a2"
    
    def search
    end
    
    def show
        @movie = TmdbMovie.find(:id => params[:id], :expand_results => true, :limit => 1)
        if( user_signed_in? )
            @selection = current_user.selections.build()
            #TODO: restrict to events that user owns or has priveleged invite to
            if( current_user.admin? )
              #admin can see everything
              @events = Event.all
            else
              #user just sees their events
              @events = current_user.all_events
            end
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
