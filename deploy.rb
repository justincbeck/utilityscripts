#!/usr/bin/env ruby
$LOAD_PATH << File.dirname(__FILE__) + '/lib'

require 'trollop'
opts = Trollop::options do
  opt :tix, "Deploy tix only"
  opt :stage, "Deploy stage only"
  opt :orders, "Deploy orders only"
  opt :people, "Deploy people only"
  opt :payments, "Deploy people only"
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
  system ("asadmin deploy --force=true components/people/target/people.war")
end

if opts[:payments] || opts[:all]
  system ("asadmin deploy --force=true components/payments/target/payments.war")
end