#!/usr/bin/env ruby

require "rubygems" # apt-get install rubygems
require "icalendar" # gem install icalendar
require "date"

cals = Icalendar::Calendar.parse($<)
cals.each do |cal|
  cal.events.each do |event|
    puts "Organizer: #{event.organizer}"
    puts "Event:     #{event.summary}"
    puts "Starts:    #{event.dtstart} local time"
    puts "Ends:      #{event.dtend}"
    puts "Location:  #{event.location}"
    # puts "Contact:   #{event.contacts}"
    puts "Description:\n#{event.description}"
    puts ""
    end
end
