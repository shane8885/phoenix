module CalendarHelper
  def month_link(month_date)
    link_to(I18n.localize(month_date, :format => "%B"), {:month => month_date.month, :year => month_date.year})
  end
  
  # custom options for this calendar
  def event_calendar_opts
    { 
      :year => @year,
      :month => @month,
      :event_strips => @event_strips,
      :month_name_text => I18n.localize(@shown_month, :format => "%B %Y"),
      :previous_month_text => "<< " + month_link(@shown_month.prev_month),
      :next_month_text => month_link(@shown_month.next_month) + " >>"    }
  end

  def event_calendar
    # args is an argument hash containing :event, :day, and :options
    calendar event_calendar_opts do |args|
      event, day = args[:event], args[:day]
      starttime = event.start.strftime("%R")
      endtime = event.end_at.strftime("%R")
      html = %(<a href="/movie_sessions/#{event.id}" title=" #{h(event.selection.movie_name)}: #{h(starttime)} - #{h(endtime)}">)
      html << display_event_time(event, day)
      html << %(#{h(event.selection.movie_name)}</a>)
      html
    end
  end
end
