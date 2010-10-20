#!/usr/bin/env ruby
$LOAD_PATH << './lib'

require 'rubygems'
require 'httparty'
require 'fakeweb'
require 'pp'
require 'json'
require 'yaml'
require 'athena'

fields = YAML.load_file('seeds/fields.yml')

fields.each do |name, field|
  response = Athena.create_field(name, field)
  ap response.parsed_response
end
