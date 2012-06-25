module Arbly
  class Checker
    def self.start
      orgs = Organization.all

      orgs.each do |o|
        if (o.payment && !o.payment.active?) || (!o.payment && o.active?)
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

        if o.payment
          if o.payment.days_left_until_rebill == 2
            BillingMailer.subscription_renewal(o).deliver
          end
        end
      end
    end
  end
end