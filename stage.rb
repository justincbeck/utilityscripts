#!/usr/bin/env ruby
$LOAD_PATH << './lib'

require 'rubygems'
require 'httparty'
require 'pp'
require 'json'
require 'yaml'
require 'athena'
require 'athena_stage'
  
fields = YAML.load_file('seeds/fields_stage.yml')

fields.each do |name, field|
  response = Athena::Stage.create_field(name, field)
  ap response.parsed_response
end
  
chart = Athena::Stage.save_template({:name => 'test chart'})
ap chart

section = {}
section['capacity'] = "4"
section['price'] = "44"
section['name'] = "GA"
section['chartId'] = chart['id']
section = Athena::Stage.save_section(section)
ap section

ap Athena::Stage.get_chart(chart['id'])

event = {}
event['name'] = "Les Miserables"
event['venue'] = "Little Theater in Brooklyn"
event['producer'] = "Jerry Seinfeld"
event = Athena::Stage.save_event(event)
ap event

event_chart = Athena::Stage.add_template_to_event(chart, event)
ap event_chart

performance = {}
performance['datetime'] = "2011-01-01T17:17:30-04:00"
performance['eventId'] = event['id']
performance['chartId'] = event_chart['id']
performance = Athena::Stage.save_performance(performance)

Athena::Tix.create_tickets(performance)