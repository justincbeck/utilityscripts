#!/usr/bin/env ruby
$LOAD_PATH << './lib'

require 'rubygems'
require 'HTTParty'
require 'pp'
require 'json'
require 'athena'
require 'athena_payments'

credit_card = Athena::CreditCard.new
credit_card.cvv = '999'
credit_card.card_number = '123456789012345'
credit_card.cardholder_name = 'John Q Ticketbuyer'
credit_card.expiration_date = '05/2012'
payments_response = Athena::Payments.authorize(4.00, credit_card)

puts payments_response.success?