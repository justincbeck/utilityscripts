#!/usr/bin/env ruby
$LOAD_PATH << './lib'

require 'rubygems'
require 'httparty'
require 'pp'
require 'json'
require 'athena'
require 'athena_payments'

credit_card = Athena::CreditCard.new
credit_card.cvv = '999'
credit_card.card_number = '4111111111111111'
credit_card.cardholder_name = 'John Q Ticketbuyer'
credit_card.expiration_date = '05/2012'
payments_response = Athena::Payments.authorize(4.00, credit_card)

puts payments_response.success?