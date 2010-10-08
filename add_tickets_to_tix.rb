require 'rubygems'
require 'HTTParty'
require 'pp'
require 'json'

class HTTParty::Request
    def perform
      puts(http_method, uri, options.body)
      validate
      setup_raw_request
      get_response
      handle_response
    end
end

class ::Hash
  def method_missing(name)
    return self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    super.method_missing name
  end
  
  def id
    self['id']
  end
end

class Tix  
  include HTTParty
  base_uri 'http://localhost:8080/tickets/'
  headers 'User-Agent' => 'load-test', 'Content-Type' => 'application/json'
  format :json
  
  def self.create_field(fld)
    self.post('http://localhost:8080/tickets/fields', :body=>fld.to_json)
  end

  def self.create_ticket(props)
    ticket = {'name' => 'ticket'}
    ticket['props'] = props    
    self.post('http://localhost:8080/tickets', :body=>ticket.to_json)
  end
end

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
  response = Tix.create_field f
  pp response.parsed_response
end

#for performances of 'Jersey Boys'
(1..2).each do |i|
  ticket_hash = Hash.new
  ticket_hash['PERFORMANCE'] = '2010-10-0' + i.to_s + ' 09:00'
  ticket_hash['SOLD'] = 'false'
  ticket_hash['VENUE'] = 'St. James Theater'
  ticket_hash['TITLE'] = 'Jersey Boys'
  
  ['A', 'B'].each do |sec|
    ticket_hash['SECTION'] = sec
    if sec.eql? 'A'
      ticket_hash['TIER'] = 'GOLD'
      ticket_hash['HALF_PRICE'] = 'false'
      ticket_hash['PRICE'] = '100'
    else
      ticket_hash['TIER'] = 'NONE'
      ticket_hash['HALF_PRICE'] = 'true'
      ticket_hash['PRICE'] = '50' 
    end
    
    (0..2).each do |seat_num|
      ticket_hash['SEAT_NUMBER'] = seat_num.to_s
      pp Tix.create_ticket(ticket_hash).parsed_response
      sleep 0.1
    end
  end    
end

