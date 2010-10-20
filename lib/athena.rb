require 'rubygems'
require 'httparty'
require 'pp'
require 'ap'
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
  headers 'User-Agent' => 'load-test', 'Content-Type' => 'application/json', 'X-ATHENA-Key' => 'TRANSACTION_TEST'
  format :json

  def self.create_field(name, field)
    field['name'] = name.upcase
    self.post(base_uri + '/fields', :body=>field.to_json)
  end

  def self.create_ticket(props)
    ticket = {'name' => 'tickets'}
    ticket['props'] = props
    self.post(base_uri + '/', :body=>ticket.to_json).parsed_response
  end

  def self.find_tickets(search_terms, limit=nil)
    query_string = search_terms.map { |k,v| "%s==%s" % [URI.encode(k.to_s), URI.encode(v.to_s)] }.join('&')
    query_string = base_uri + '/?' + query_string

    if(!limit.nil?)
      query_string = query_string = query_string + '&_limit=' + limit.to_s
    end

    tickets = self.get(query_string).parsed_response
    tickets
  end

  def self.lock_tickets(ticket_ids)
    tran = Hash.new
    tran['tickets'] = ticket_ids
    response = self.post(base_uri + '/transactions', :body=>tran.to_json)
    response.parsed_response
  end

  def self.renew_lock(tran)
    tran['status']='RENEW'
    response = self.put(base_uri + '/transactions/' + tran.id, :body=>tran.to_json)
    response.parsed_response
  end

  def self.delete_lock(tran)
    response = self.delete(base_uri + '/transactions/' + tran.id)
    response.parsed_response
  end

  def self.checkout(tran)
    response = self.put(base_uri + '/transactions/' + tran.id, :body=>tran.to_json)
    response.parsed_response
  end
end
