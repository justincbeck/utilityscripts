require 'rubygems'
require 'httparty'
require 'pp'
require 'ap'
require 'json'
require 'active_support'

module Athena
  class CreditCard
    attr_accessor(:card_number, :expiration_date, :cardholder_name, :cvv)
  end
  
  class PaymentsRequest
    attr_accessor(:amount, :credit_card)
  end
  
  class PaymentsResponse
    attr_accessor(:success)
    
    def success?
      success
    end
  end
  
  class Payments
    include HTTParty
    base_uri 'http://localhost:8080/payments/transactions/'
    headers 'User-Agent' => 'load-test', 'Content-Type' => 'application/json', 'X-ATHENA-Key' => 'PAYMENTS_TEST'
    format :json
    
    def self.authorize(amount, credit_card)
      payments_request = Athena::PaymentsRequest.new
      payments_request.amount = amount
      payments_request.credit_card = credit_card
      http_response = self.post(base_uri + '/authorize', :body=>JSON.encode(payments_request))
      ap http_response.parsed_response
      payments_response = Athena::PaymentsResponse.new
      payments_response.success = true
      payments_response
    end
  end
end