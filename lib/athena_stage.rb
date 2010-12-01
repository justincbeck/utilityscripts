require 'rubygems'
require 'httparty'
require 'pp'
require 'ap'
require 'json'
require 'active_support'

module Athena
  
  class Stage
    include HTTParty
    base_uri 'http://localhost:8080/stage/'
    headers 'User-Agent' => 'athena-stage-client', 'Content-Type' => 'application/json', 'X-ATHENA-Key' => 'PAYMENTS_TEST'
    format :json
    
    def self.create_field(name, field)
      field['name'] = name
      self.post(base_uri + '/meta/fields', :body=>field.to_json)
    end
    
    def self.get_event(event_id)
      self.get(base_uri + '/events/' + event_id).parsed_response
    end
    
    def self.save_event(event)
      if event['id'].nil?
        self.post(base_uri + '/events', :body=>event.to_json).parsed_response
      else
        self.put(base_uri + '/events/' + event['id']).parsed_response
      end
    end    
    
    def self.get_performance(performance_id)
      self.get(base_uri + '/performances/' + performance_id).parsed_response
    end

    def self.save_performance(performance)
      if performance['id'].nil?
        self.post(base_uri + '/performances', :body=>performance.to_json).parsed_response
      else
        self.put(base_uri + '/performance/' + event['id']).parsed_response
      end
    end


    def self.get_chart(chart_id)
      self.get(base_uri + '/charts/' + chart_id).parsed_response
    end
    
    def self.save_chart(chart)
      if chart['id'].nil?
        self.post(base_uri + '/charts', :body=>chart.to_json).parsed_response
      else
        self.put(base_uri + '/charts/' + chart['id'], :body=>chart.to_json).parsed_response
      end
    end
  end
end