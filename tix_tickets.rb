#!/usr/bin/env ruby
$LOAD_PATH << './lib'

require 'rubygems'
require 'httparty'
require 'fakeweb'
require 'pp'
require 'json'
require 'yaml'
require 'athena'

ticket = {}
ticket['performance'] = "2010-10-20T17:17:30-04:00"
ticket['sold'] = 'false'
ticket['venue'] = 'St. James Theater'
ticket['event'] = 'Oklahoma'


[50,100].each do |price|
  ticket['price'] = price
  10.times do
    ap Athena::Tix.create_ticket(ticket)
  end
end
