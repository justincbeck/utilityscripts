#!/usr/bin/env ruby
$LOAD_PATH << './lib'

require 'rubygems'
require 'HTTParty'
require 'pp'
require 'json'
require 'athena'

search_hash = Hash.new
search_hash['PRICE'] = '50'
tickets = Athena::Tix.find_tickets(search_hash)
pp tickets
tickets = Athena::Tix.find_tickets(search_hash, 2)
pp tickets