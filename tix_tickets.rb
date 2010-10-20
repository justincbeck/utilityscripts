#!/usr/bin/env ruby
$LOAD_PATH << './lib'

require 'rubygems'
require 'httparty'
require 'fakeweb'
require 'pp'
require 'json'
require 'yaml'
require 'athena'

(1..2).each do |i|
  ticket_hash = Hash.new
  ticket_hash['PERFORMANCE'] = '2010-11-0' + i.to_s + 'T09:00:00-04:00'
  ticket_hash['SOLD'] = 'false'
  ticket_hash['VENUE'] = 'St. James Theater'
  ticket_hash['TITLE'] = 'Oklahoma'

  ['A', 'B'].each do |sec|
    ticket_hash['SECTION'] = sec
    if sec.eql? 'A'
      ticket_hash['TIER'] = 'GOLD'
      ticket_hash['PRICE'] = '100'
    else
      ticket_hash['TIER'] = 'NONE'
      ticket_hash['PRICE'] = '50'
    end

    (0..2).each do |seat_num|
      ticket_hash['SEAT_NUMBER'] = seat_num.to_s
      ap Athena.create_ticket(ticket_hash)
    end
  end
end
