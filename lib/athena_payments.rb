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
  
  class Athena::PaymentsRequest
      def to_json(*a) {	
	  'creditCard'   => credit_card,
	  'amount'       => amount.to_s
        }.to_json(*a)
      end

      def self.json_create(o)
      	  new(*o['amount','credit_card', 'order_id'])
      end
  end

  class Athena::CreditCard
      def to_json(*a) {
          'cardNumber'     => card_number,
	  'expirationDate' => expiration_date,
	  'cardholderName' => cardholder_name,
	  'cvv' 	   => cvv
	  }.to_json(*a)
      end

      def self.json_create(o)
          new(*o['card_number','expiration_date', 'cardholder_name', 'cvv'])
      end
  end

  class Payments
    include HTTParty
    base_uri Athena::ATHENA_HOME_URI + '/payments'
    headers 'User-Agent' => 'load-test', 'Content-Type' => 'application/json', 'X-ATHENA-Key' => 'PAYMENTS_TEST'
    format :json
    
    def self.authorize(amount, credit_card)
      payments_request = Athena::PaymentsRequest.new

      payments_request.amount = amount
      payments_request.credit_card = credit_card
      payments_request.credit_card.card_number = credit_card.card_number 
      payments_request.credit_card.expiration_date = credit_card.expiration_date   

      http_response = self.post(base_uri + '/transactions/authorize', :body=>payments_request.to_json)

      ap http_response.parsed_response
      payments_response = Athena::PaymentsResponse.new
      payments_response.success = true
      payments_response
    end
  end
end