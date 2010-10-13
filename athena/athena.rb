require 'rubygems'
require 'HTTParty'
require 'pp'
require 'json'
require 'active_support'

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
    #super.method_missing name
  end
  
  def id
    self['id']
  end
end

class Athena  
  include HTTParty
  base_uri 'http://localhost:8080/tickets/'
  headers 'User-Agent' => 'load-test', 'Content-Type' => 'application/json', 'X=ATHENA-Key' => 'TRANSACTION_TEST'
  format :json
  
  def self.create_field(fld)
    self.post(base_uri + '/fields', :body=>fld.to_json)
  end

  def self.create_ticket(props)
    ticket = {'name' => 'tickets'}
    ticket['props'] = props    
    self.post(base_uri, :body=>ticket.to_json)
  end
  
  def self.find_tickets(search_terms)
    query_string = search_terms.map { |k,v| "%s==%s" % [URI.encode(k.to_s), URI.encode(v.to_s)] }.join('&')
    tickets = self.get(base_uri + '/?' + query_string).parsed_response
    pp tickets
    tickets
  end
  
  def self.lock_tickets(ticket_ids)
    tran = Hash.new
    tran['tickets'] = ticket_ids
    response = self.post(base_uri + '/transactions', :body=>tran.to_json)   
    response.parsed_response
  end
  
  def self.renew_lock(tran)
    response = self.put(base_uri + '/transactions/' + tran.id, :body=>tran.to_json)   
    response.parsed_response    
  end  

  def self.checkout(tran)
    response = self.put(base_uri + '/transactions/' + tran.id, :body=>tran.to_json)   
    response.parsed_response    
  end
end