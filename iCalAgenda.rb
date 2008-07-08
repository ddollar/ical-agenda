#!/usr/bin/env ruby

# dependencies
#   rb-appscript >= 0.5.1

# usage: iCalAgenda.rb [-a]
#   defaults to showing only future events
#   use the -a flag to show all

require 'rubygems'
require 'appscript'
require 'pp'

SHOW_ALL = ARGV.first == '-a'

calendar_events = {}

ical = Appscript::app('iCal')

ical.calendars.get.each do |calendar|

  calendar_name = calendar.name.get
  calendar_events[calendar_name] = []

  calendar.events.get.each do |event|
    event = {
      :summary => event.summary.get,
      :start => event.start_date.get,
      :end => event.end_date.get,
      :allday => event.allday_event.get
    }
    calendar_events[calendar_name] << event if SHOW_ALL || event[:start] > Time.now
  end

end

calendar_events.keys.sort.each do |calendar|
  events = calendar_events[calendar]

  next if events.length == 0
  
  puts "#{calendar}"
  puts

  events.sort_by { |e| e[:start] }.each do |event|
    start = event[:start].strftime("%m-%d-%Y")
    puts "[#{start}] #{event[:summary]}"
  end

  puts
  puts "*" * 80
  puts
   
end