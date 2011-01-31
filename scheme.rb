#!/usr/bin/env ruby
$LOAD_PATH << './lib'

require 'rubygems'
require 'httparty'
require 'fakeweb'
require 'pp'
require 'json'
require 'yaml'
require 'athena'

component_name = ARGV[0]
fields = YAML.load_file('seeds/fields_' + component_name + '.yml')

fields.each do |name, field|
  p name
  p field
  response = Athena::Util.create_field(component_name, name, field)
  ap response.parsed_response
end
