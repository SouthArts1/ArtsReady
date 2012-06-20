require 'logger'
%w( 
  version
  lib/org
).each{|f| require File.dirname(__FILE__) + '/arbly/' + f }


module Arbly
  class Loader
    def self.do
      # puts "Starting MailFetcher"
      # ChocolateRain::MailFetcher.start
      # puts "Starting FtpMachine"
      # ChocolateRain::FtpMachine.start
      # puts "All started"
    end
    
  end
end