module EventsHelper

  def event_poster_url(event)
    if(event.selections.last.nil?)
      'no_poster.jpg'
    else
      event.selections.last.poster
    end
  end
  
  def event_name(event)
    if user_signed_in?
      if( current_user.authorized?(event.user_id) or current_user.invited_to?(event) )
        link_to event.name,event
      else
        event.name
      end
    else
      event.name
    end
  end
end
