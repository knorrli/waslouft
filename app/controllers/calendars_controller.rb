class CalendarsController < ApplicationController
  def show
    respond_to do |format|
      format.ics do
        cal = Icalendar::Calendar.new
        cal.x_wr_calname = 'Awesome Rails Calendar'
        Event.order(start_date: :asc).each do |event|
          cal.event do |e|
            e.dtstart = event.start_date
            e.dtend = event.start_date.end_of_day
            e.summary = event.title
            e.description = event.location.name
          end
        end
        cal.publish
        render plain: cal.to_ical
      end
    end
  end
end
