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
ticket['PERFORMANCE'] = "2010-10-20T17:17:30-04:00"
ticket['SOLD'] = 'false'
ticket['VENUE'] = 'St. James Theater'
ticket['EVENT'] = 'Oklahoma'


[50,100].each do |price|
  ticket['PRICE'] = price
  10.times do
    ap Athena.create_ticket(ticket)
  end
end
