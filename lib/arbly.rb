module Arbly
  class Checker
    def self.start
      orgs = Organization.all

      orgs.each do |o|
        if (o.subscription && !o.subscription.active?) || (!o.subscription && o.active?)
          BillingMailer.setup_subscription_now(o).deliver
          begin
            if ((Time.now - o.created_at).to_i / (24 * 60 * 60)) > 2
              o.update_attribute(:active, false)
              AdminMailer.organization_expired(o).deliver
            end
          rescue Exception => e
            # rescue
          end
        end

        # This code is broken in at least two ways:
        #
        # 1. An error in `AdminMailer#subscription_renewal` prevents any
        #    email from being sent.
        # 2. If it were being sent, it would be sent to organizations with
        #    cancelled subscriptions.
        #
        # Fixing #1 would make #2 an issue, so for now, we're just
        # commenting out the code. Email will still not be sent, but
        # now it won't generate errors (and prevent todo reminders)
        # in the process.

        # if o.subscription
        #   if o.subscription.days_left_until_rebill == 2
        #     BillingMailer.subscription_renewal(o).deliver
        #   end
        # end
      end
    end
  end
end