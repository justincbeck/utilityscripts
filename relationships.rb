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

event = {}
event['name'] = "Les Miserables"
event['venue'] = "Little Theater in Brooklyn"
event['producer'] = "Jerry Seinfeld"
event = Athena::Stage.save_event(event)
ap event


performance = {}
performance['datetime'] = "2011-01-01T17:17:30-04:00"
performance['eventId'] = event['id']
performance = Athena::Stage.save_performance(performance)


performance = {}
performance['datetime'] = "2011-01-02T17:17:30-04:00"
performance['eventId'] = event['id']
performance = Athena::Stage.save_performance(performance)

ap Athena::Stage.get_performances_by_event(event)