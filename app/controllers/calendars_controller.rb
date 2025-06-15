class CalendarsController < ApplicationController
  def show
    respond_to do |format|
      format.ics do
        cal = Icalendar::Calendar.new
        cal.x_wr_calname = 'WasLouft'
        Event.order(start_date: :asc).each do |event|
          cal.event do |e|
            # e.dtstart = event.start_date.strftime('%Y%m%d')
            e.dtstart = Icalendar::Values::Date.new(event.start_date.strftime('%Y%m%d'))
            # e.dtend = event.start_date.end_of_day
            e.uid = "gid:/waslouft/events/#{event.id}"
            e.summary = event.title
            e.location = event.location.name
            e.description = event.subtitle
            e.url = event.url
          end
        end
        cal.publish
        render plain: cal.to_ical
      end
    end
  end
end
