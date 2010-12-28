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

module Athena  

  #local
  ATHENA_HOME_URI = 'http://localhost:8080'
  
  #dev
  #ATHENA_HOME_URI = 'http://184.73.209.105:8888'
  
  class Util
    include HTTParty
    base_uri Athena::ATHENA_HOME_URI
    headers 'User-Agent' => 'load-test', 'Content-Type' => 'application/json', 'X-ATHENA-Key' => 'TRANSACTION_TEST'
    format :json

    def self.create_field(component, name, field)
      field['name'] = name
      self.post(base_uri + '/' + component + '/meta/fields', :body=>field.to_json)
    end
  end
  
  class Tix
    include HTTParty
    base_uri Athena::ATHENA_HOME_URI + '/tix/'
    headers 'User-Agent' => 'load-test', 'Content-Type' => 'application/json', 'X-ATHENA-Key' => 'TRANSACTION_TEST'
    format :json

    def self.create_field(name, field)
      field['name'] = name
      self.post(base_uri + '/meta/fields', :body=>field.to_json)
    end

    def self.create_ticket(props)
      ticket = Hash.new
      ticket.merge! props
      self.post(base_uri + '/tickets', :body=>ticket.to_json).parsed_response
    end

    def self.find_tickets(search_terms, limit=nil)
      query_string = search_terms.map { |k,v| "%s=eq%s" % [URI.encode(k.to_s), URI.encode(v.to_s)] }.join('&')
      query_string = base_uri + '/tickets?' + query_string

      if(!limit.nil?)
        query_string = query_string = query_string + '&_limit=' + limit.to_s
      end

      tickets = self.get(query_string).parsed_response
      tickets
    end

    def self.lock_tickets(ticket_ids)
      lock = Hash.new
      lock['tickets'] = ticket_ids
      response = self.post(base_uri + '/meta/locks', :body=>lock.to_json)
      response.parsed_response
    end

    def self.get_lock(lockId)
      lock = Hash.new
      response = self.get(base_uri + '/meta/locks/' + lockId.to_s)
      response.parsed_response
    end

    def self.renew_lock(lock)
      lock['status']='RENEW'
      lock['lockExpires'] = format_date_for_athena(lock['lockExpires'])
      response = self.put(base_uri + '/meta/locks/' + lock.id, :body=>lock.to_json)
      response.parsed_response
    end

    def self.delete_lock(lock)
      response = self.delete(base_uri + '/meta/locks/' + lock.id)
      response.parsed_response
    end

    def self.checkout(lock)
      lock['lockExpires'] = format_date_for_athena(lock['lockExpires'])
      response = self.put(base_uri + '/meta/locks/' + lock.id, :body=>lock.to_json)
      response.parsed_response
    end
    
    def self.format_date_for_athena(d)
      d.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
    end
    
    def self.create_tickets(performance)
      self.post(base_uri + '/meta/ticketfactory', :body=>performance.to_json).parsed_response
    end
  end  
end
