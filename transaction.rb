#!/usr/bin/env ruby
$LOAD_PATH << './lib'

require 'rubygems'
require 'HTTParty'
require 'pp'
require 'json'
require 'athena'

ticket_hash = Hash.new
(0..20).each do |seat_num|
  ticket_hash['venue'] = 'Venue name'
  ticket_hash['event'] = 'Event name'
  pp Athena::Tix.create_ticket(ticket_hash).parsed_response
  sleep 0.1
end

#Find some tickets
search_hash = Hash.new
search_hash['venue'] = 'Venue name'
tickets = Athena::Tix.find_tickets(search_hash)

#lock the first two
ticket1 = tickets[0]
ticket2 = tickets[1]
ticket_ids = Array.new
ticket_ids << ticket1.id
ticket_ids << ticket2.id
transaction = Athena::Tix.lock_tickets(ticket_ids)
pp transaction

#hang out for a bit
sleep 1

#renew the lock
transaction = Athena::Tix.renew_lock(transaction)
ap transaction

sleep 0.5

#renew the lock, this should fail
Athena::Tix.renew_lock(transaction)

sleep 3

#now delete the transaction
transaction = Athena::Tix.delete_lock(transaction)
