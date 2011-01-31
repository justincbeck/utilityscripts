#!/usr/bin/env ruby
$LOAD_PATH << File.dirname(__FILE__) + '/lib'

require 'trollop'
opts = Trollop::options do
  banner <<-EOS
    This script will deploy compiled war files to glassfish

    Usage:
         deploy.rb [options] where [options] are:
         
    EOS
  
  opt :tix, "Deploy tix"
  opt :stage, "Deploy stage"
  opt :orders, "Deploy orders"
  opt :people, "Deploy people"
  opt :payments, "Deploy payments"
  opt :audit, "Deploy auditing"
  opt :all, "Deploy all"
end

if opts[:tix] || opts[:all]
  system ("asadmin deploy --force=true components/tix/target/tix.war")
end

if opts[:stage] || opts[:all]
  system ("asadmin deploy --force=true components/stage/target/stage.war")
end

if opts[:people] || opts[:all]
  system ("asadmin deploy --force=true components/people/target/people.war")
end

if opts[:orders] || opts[:all]
  system ("asadmin deploy --force=true components/orders/target/orders.war")
end

if opts[:payments] || opts[:all]
  system ("asadmin deploy --force=true components/payments/target/payments.war")
end

if opts[:audit] || opts[:all]
  system ("asadmin deploy --force=true components/audit-server/target/audit.war")
end