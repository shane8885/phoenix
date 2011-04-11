module EventsHelper

  def event_poster_url(event)
    if(event.selections.last.nil?)
      'no_poster.jpg'
    else
      event.selections.last.poster
    end
  end
end
