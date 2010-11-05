require 'rubygems'
require 'HTTParty'
require 'pp'
require 'json'

#add fields
seat_number = {'valueType'=>'STRING', 'name'=>'seatNumber', 'strict'=>'false'}
section = {'valueType'=>'STRING', 'name'=>'section', 'strict'=>'false'}
tier = {'valueType'=>'STRING', 'name'=>'tier', 'strict'=>'false'}
performance = {'valueType'=>'DATETIME', 'name'=>'performance', 'strict'=>'false'}
sold = {'valueType'=>'BOOLEAN', 'name'=>'sold', 'strict'=>'false'}
price = {'valueType'=>'INTEGER', 'name'=>'price', 'strict'=>'false'}
venue = {'valueType'=>'STRING', 'name'=>'venue', 'strict'=>'false'}
title = {'valueType'=>'STRING', 'name'=>'title', 'strict'=>'false'}
half_price = {'valueType'=>'BOOLEAN', 'name'=>'halfPrice', 'strict'=>'false'}

fields_to_add = [seat_number, section, tier, performance, sold, price, venue, title, half_price]

fields_to_add.each do |f|
  response = Athena::Tix.create_field f
  pp response.parsed_response
end

#for five performances of 'Jersey Boys'
(0..3).each do |i|
  ticket_hash = Hash.new
  ticket_hash['performance'] = '2010-10-0' + i.to_s + ' 09:00'

  ['A', 'B', 'C'].each do |sec|
    ticket_hash['section'] = sec
    if sec.eql? 'A'
      ticket_hash['tier'] = 'GOLD'
    else
      ticket_hash['tier'] = 'NONE'
    end

    pp Athena::Tix.find_tickets(ticket_hash).parsed_response
  end
end

