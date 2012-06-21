require 'arbly'

namespace :arbly do
	
	desc "Billing Notifications"
	task :notifier => :environment do
		Arbly::Checker.start
	end
end
