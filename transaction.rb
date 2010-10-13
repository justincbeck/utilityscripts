require 'rubygems'
require 'HTTParty'
require 'pp'
require 'json'
require 'athena/athena.rb'

#add fields
seat_number = {'valueType'=>'STRING', 'name'=>'SEAT_NUMBER', 'strict'=>'false'}
section = {'valueType'=>'STRING', 'name'=>'SECTION', 'strict'=>'false'}
tier = {'valueType'=>'STRING', 'name'=>'TIER', 'strict'=>'false'}
performance = {'valueType'=>'DATETIME', 'name'=>'PERFORMANCE', 'strict'=>'false'}
sold = {'valueType'=>'BOOLEAN', 'name'=>'SOLD', 'strict'=>'false'}
price = {'valueType'=>'INTEGER', 'name'=>'PRICE', 'strict'=>'false'}
venue = {'valueType'=>'STRING', 'name'=>'VENUE', 'strict'=>'false'}
title = {'valueType'=>'STRING', 'name'=>'TITLE', 'strict'=>'false'}
half_price = {'valueType'=>'BOOLEAN', 'name'=>'HALF_PRICE', 'strict'=>'false'}

transactionId = {'valueType'=>'STRING', 'name'=>'TRANSACTION_ID', 'strict'=>'false'}
lockedByIp = {'valueType'=>'STRING', 'name'=>'LOCKED_BY_IP', 'strict'=>'false'}
lockedByApiKey = {'valueType'=>'STRING', 'name'=>'LOCKED_BY_API_KEY', 'strict'=>'false'}
lockExpires = {'valueType'=>'DATETIME', 'name'=>'LOCK_EXPIRES', 'strict'=>'false'}
lockTimes = {'valueType'=>'INTEGER', 'name'=>'LOCK_TIMES', 'strict'=>'false'}

fields_to_add = [seat_number, section, tier, performance, sold, price, venue, title, half_price, transactionId, lockedByIp, lockedByApiKey, lockExpires, lockTimes]

fields_to_add.each do |f|
  response = Athena.create_field f
  # pp response.parsed_response
end

ticket_hash = Hash.new
(0..20).each do |seat_num|
  ticket_hash['SEAT_NUMBER'] = seat_num.to_s
  ticket_hash['SECTION'] = 'ORCHESTRA'
  pp Athena.create_ticket(ticket_hash).parsed_response
  sleep 0.1
end

#Find some tickets
search_hash = Hash.new
search_hash['SECTION'] = 'ORCHESTRA'
tickets = Athena.find_tickets(search_hash)

#lock the first two
ticket1 = tickets[0]
ticket2 = tickets[1]
ticket_ids = Array.new
ticket_ids << ticket1.id
ticket_ids << ticket2.id
transaction = Athena.lock_tickets(ticket_ids)
pp transaction

#hang out for a bit
sleep 60

#renew the lock
transaction = Athena.renew_lock(transaction)
pp transaction

sleep 0.5

#renew the lock
transaction = Athena.renew_lock(transaction)
pp transaction