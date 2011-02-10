#!/usr/bin/env ruby
$LOAD_PATH << './lib'

require 'rubygems'
require 'HTTParty'
require 'pp'
require 'json'
require 'athena'

class Array
  def sum
    inject(0.0) { |result, el| result + el }
  end

  def mean 
    sum / size
  end
end

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
a = {'valueType'=>'STRING', 'name'=>'a', 'strict'=>'false'}
b = {'valueType'=>'STRING', 'name'=>'b', 'strict'=>'false'}
c = {'valueType'=>'STRING', 'name'=>'c', 'strict'=>'false'}
d = {'valueType'=>'STRING', 'name'=>'d', 'strict'=>'false'}
e = {'valueType'=>'STRING', 'name'=>'e', 'strict'=>'false'}
f = {'valueType'=>'STRING', 'name'=>'f', 'strict'=>'false'}
g = {'valueType'=>'STRING', 'name'=>'g', 'strict'=>'false'}
h = {'valueType'=>'STRING', 'name'=>'h', 'strict'=>'false'}
i = {'valueType'=>'STRING', 'name'=>'i', 'strict'=>'false'}
j = {'valueType'=>'STRING', 'name'=>'j', 'strict'=>'false'}
k = {'valueType'=>'STRING', 'name'=>'k', 'strict'=>'false'}
l = {'valueType'=>'STRING', 'name'=>'l', 'strict'=>'false'}
m = {'valueType'=>'STRING', 'name'=>'m', 'strict'=>'false'}
n = {'valueType'=>'STRING', 'name'=>'n', 'strict'=>'false'}
o = {'valueType'=>'STRING', 'name'=>'o', 'strict'=>'false'}

fields_to_add = [seat_number, section, tier, performance, sold, price, venue, title, half_price, a, b, c, d, e, f, g, h, i, j, k, l , m, n, o]

fields_to_add.each do |f|
  response = Athena::Tix.create_field f['name'], f
  pp response.parsed_response
end

all_times = Array.new
all_times_splits = {}
num_days = 30
num_tickets_per_day = 300

(1..num_days).each do |day|
  ticket_hash = Hash.new
  ticket_hash['performance'] = '2011-08-' + day.to_s + 'T09:00:00-04:00'
  ticket_hash['price'] = rand(300)
  all_times_splits[day] = Array.new
    (0..num_tickets_per_day).each do |seat_num|
      ticket_hash['halfPrice'] = (ticket_hash['price'] % 2 == 0)
    
      ticket_hash['section'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['tier'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['venue'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['a'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['b'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['c'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['d'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['e'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['f'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['g'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['h'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['i'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['j'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['k'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['l'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['m'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['n'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['o'] = (0...5).map{ ('a'..'z').to_a[rand(26)] }.join
      ticket_hash['seatNumber'] = seat_num.to_s
    
      start = Time.now
      Athena::Tix.create_ticket(ticket_hash).parsed_response
      finish = Time.now
      duration = finish-start
      all_times << duration
      all_times_splits[day] << duration
      #p duration
    end
end

puts "#{all_times.size} tickets created"
puts "#{all_times.mean} average time"
(1..num_days).each do |day|
  puts "#{all_times_splits[day].mean} average time for #{day}"
end