require 'rubygems'
require 'HTTParty'
require 'pp'
require 'json'

class HTTParty::Request
    def perform
      puts(http_method, uri, options['body'])
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
  base_uri 'http://localhost:8080/parakeet/'
  headers 'User-Agent' => 'load-test', 'Content-Type' => 'application/json'
  format :json
  
  def self.create_field(fld)
    self.post('http://localhost:8080/parakeet/fields', :body=>fld.to_json)
  end

  def self.create_ticket(props)
    ticket = {'name' => 'ticket'}
    ticket['props'] = props    
    self.post('http://localhost:8080/parakeet', :body=>ticket.to_json)
  end
  
  def self.find_tickets(props)
    uri = 'http://localhost:8080/parakeet?'
    props.each do |k,v|
      uri += k + '=' + v + '&'
    end
    self.get(URI.encode(uri))
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

fields_to_add = [seat_number, section, tier, performance, sold, price, venue, title, half_price]

fields_to_add.each do |f|
  response = Tix.create_field f
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
    
    pp Tix.find_tickets(ticket_hash).parsed_response
  end    
end

