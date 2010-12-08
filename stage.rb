#!/usr/bin/env ruby
$LOAD_PATH << './lib'

require 'rubygems'
require 'httparty'
require 'fakeweb'
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
  
chart = Athena::Stage.save_chart({:name => 'test chart'})
ap chart

ap Athena::Stage.get_chart(chart['id'])

event = {}
event['name'] = "Les Miserables"
event['venue'] = "Little Theater in Brooklyn"
event['producer'] = "Jerry Seinfeld"
event['chartId'] = chart['id']
event = Athena::Stage.save_event(event)
ap event

(1..12).each do |day|
  performance = {}
  performance['datetime'] = "2011-01-" + day.to_s + "T17:17:30-04:00"
  performance['eventId'] = event['id']
  performance['chartId'] = chart['id']
  ap Athena::Stage.save_performance(performance)
end