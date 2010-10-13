require 'rubygems'
require 'HTTParty'
require 'pp'
require 'json'

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

fields_to_add = [seat_number, section, tier, performance, sold, price, venue, title, half_price]

fields_to_add.each do |f|
  response = Athena.create_field f
  pp response.parsed_response
end

#for five performances of 'Jersey Boys'
(0..3).each do |i|
  ticket_hash = Hash.new
  ticket_hash['PERFORMANCE'] = '2010-10-0' + i.to_s + ' 09:00'
  
  ['A', 'B', 'C'].each do |sec|
    ticket_hash['SECTION'] = sec
    if sec.eql? 'A'
      ticket_hash['TIER'] = 'GOLD'
    else
      ticket_hash['TIER'] = 'NONE'
    end
    
    pp Athena.find_tickets(ticket_hash).parsed_response
  end    
end

