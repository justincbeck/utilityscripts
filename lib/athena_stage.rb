require 'rubygems'
require 'httparty'
require 'pp'
require 'ap'
require 'json'
require 'active_support'

module Athena  
  class Stage
    include HTTParty
    base_uri Athena::ATHENA_HOME_URI + '/stage/'
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

    def self.save_section(section)
      if section['id'].nil?
        self.post(base_uri + '/sections', :body=>section.to_json).parsed_response
      else
        self.put(base_uri + '/sections/' + section['id'], :body=>section.to_json).parsed_response
      end
    end
    
    def self.get_sections_for_chart(chart)
      sections = self.get(base_uri + '/sections/?chartId=eq' + chart['id']).parsed_response
    end

    def self.get_chart(chart_id)
      self.get(base_uri + '/charts/' + chart_id).parsed_response
    end
    
    def self.save_template(chart)
      chart['isTemplate'] = 'true'
      self.save_chart(chart)
    end
    
    def self.save_chart(chart)
      if chart['id'].nil?
        self.post(base_uri + '/charts', :body=>chart.to_json).parsed_response
      else
        self.put(base_uri + '/charts/' + chart['id'], :body=>chart.to_json).parsed_response
      end
    end
    
    def self.add_template_to_event(chart, event)
      sections = self.get_sections_for_chart(chart)
      chart['eventId'] = event['id']
      chart['isTemplate'] = 'false'
      chart['id'] = nil
      chart = self.save_chart(chart)
      
      sections.each do |section|
        section['chartId'] = chart['id']
        section['id'] = nil
        self.save_section(section)
      end
      
      chart
    end
    
    def self.get_performances_by_event(event)
      self.get(base_uri + '/events/' + event['id'] + '/performances').parsed_response
    end
  end
end