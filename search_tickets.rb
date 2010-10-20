require 'rubygems'
require 'HTTParty'
require 'pp'
require 'json'
require 'athena'

search_hash = Hash.new
search_hash['SECTION'] = 'B'
tickets = Athena.find_tickets(search_hash)
pp tickets
tickets = Athena.find_tickets(search_hash, 2)
pp tickets