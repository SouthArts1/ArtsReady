class Organization < ActiveRecord::Base
  include Gmaps4rails::ActsAsGmappable
  acts_as_gmappable validation: false
  geocoded_by :full_street_address

  has_one :assessment, -> { order('created_at DESC') }, :dependent => :destroy
  has_many :assessments, :dependent => :destroy
  has_one :crisis, -> { where("resolved_on IS NULL") } #TODO ensure there is only one, and maybe sort by latest date as a hack
  has_many :articles
  has_many :public_articles, -> { where("visibility = 'public'") },
    :class_name => 'Article',
    :dependent => :nullify
  has_many :non_public_articles, -> { where("visibility <> 'public'") },
    :class_name => 'Article',
    :dependent => :destroy
  has_many :comments, :through => :articles
  has_many :battle_buddy_requests, :dependent => :destroy
  has_many :battle_buddies,
    -> { where(:battle_buddy_requests => {:accepted => true}) },
    :through => :battle_buddy_requests
  has_many :battle_buddy_requests_received, -> { where("battle_buddy_requests.accepted IS NOT true") }, :class_name => 'BattleBuddyRequest', :foreign_key => 'battle_buddy_id'
  has_many :battle_buddy_requests_sent, -> { where("battle_buddy_requests.accepted IS NOT true") }, :class_name => 'BattleBuddyRequest'
  has_many :crises, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  has_many :resources, :dependent => :destroy
  has_many :todos, :dependent => :destroy
  has_many :updates, :dependent => :destroy
  has_many :users, :dependent => :destroy
  has_many :managers, -> { where("users.role = 'manager'") }, :class_name => 'User'
  has_many :executives, -> { where("users.role = 'executive'") }, :class_name => 'User'
  has_many :editors, -> { where("users.role = 'editor'") }, :class_name => 'User'
  has_many :readers, -> { where("users.role = 'reader'") }, :class_name => 'User'
  has_many :subscriptions, -> { order(:start_date) }
  has_one :active_subscription, -> { where(subscriptions: {active: true}) },
    class_name: 'Subscription'
  has_many :subscription_events
  has_many :payments, -> { order('subscription_events.happened_at ASC') },
    through: :subscription_events

  accepts_nested_attributes_for :users

  validates_presence_of :name, :address, :city, :state, :zipcode, :organizational_status

  # disabled as app approaches EOL
  # after_validation :geocode, :if => lambda{ |obj| (obj.changed.include?("address") || obj.changed.include?("city") || obj.changed.include?("state") || obj.changed.include?("zipcode"))  }

  after_create :send_admin_notification
  after_update :send_approval_email, :if => lambda{ |obj| (obj.changed.include?("active") && obj.active?)  }
  after_update :setup_initial_todo, :if => lambda{ |obj| (obj.changed.include?("active") && obj.active?)  }

  # disabled as app approaches EOL
  # after_save :update_salesforce

  scope :active, -> { where(:active => true) }
  scope :in_buddy_network, -> { where(:battle_buddy_enabled => true) }
  scope :to_approve, -> { where(:active => false) }
  scope :nearing_expiration, -> { where('0=1') }
  scope :in_crisis, -> { includes(:crisis).where('crises.resolved_on IS NULL') }
  scope :billing_next_month, -> {
    next_month = Time.zone.today + 1.month

    where("next_billing_date BETWEEN ? and ?",
      next_month.beginning_of_month,
      next_month.end_of_month
    )
  }
  scope :renewing_in, lambda { |days|
    active.where(next_billing_date: Time.zone.today + days)
  }
  scope :credit_card_expiring_this_month, -> {
    active.
      joins(:active_subscription).
      merge(Subscription.credit_card_expiring_this_month)
  }

  delegate :complete?, :to => :assessment, :allow_nil => true, :prefix => true
  delegate :percentage_complete, :to => :assessment, :allow_nil => true, :prefix => true
  delegate :billing_first_name, :billing_last_name,
    :billing_address, :billing_city, :billing_state, :billing_zipcode,
    :payment_method, :payment_number,
    :discount_code, :next_billing_amount,
    to: :subscription, allow_nil: true
  delegate :identifier, to: :discount_code, prefix: true, allow_nil: true

  def self.with_user_activity_since(last=1.week.ago)
    active.select('DISTINCT organizations.id').joins(:users).where('users.last_login_at > ?',last)
  end
  
  def self.activity_percentage(last=1.week.ago)
    ((Organization.with_user_activity_since(last).count.to_f / Organization.active.count.to_f)*100).to_i rescue 0
  end

  def contact_first_name
    split_name(contact_name).first
  end

  def contact_last_name
    split_name(contact_name).last
  end

  def split_name(name)
    return [nil, nil] if name.blank?

    name = name.split(/,/, 2).first # remove honorifics
    words = name.split(/\s+/)
    [words[0..-2].join(' '), words[-1]].map(&:presence)
  end

  def full_street_address
    [address, city, state, zipcode].compact.join(', ')
  end

  def gmaps4rails_address
    full_street_address
  end

  def deletable?
    # must deactivate an organization before deleting it
    !active? && users.all?(&:disabled?)
  end
    
  def battle_buddy_list
    battle_buddies.collect(&:id).uniq
  end

  def battle_buddy_request_for(buddy)
    battle_buddy_requests.find_by_battle_buddy_id(buddy)
  end

  def last_activity
    users.order('last_login_at DESC').first.try(:last_activity)
  end

  def declared_crisis?
    crises.where(:resolved_on => nil).count == 1 ? true : false
  end

  def todo_percentage_complete
    ((todos.completed.count.to_f / todos.count.to_f)*100).to_i rescue 0
  end
  
  def build_provisional_subscription
    ProvisionalSubscription.new(organization: self)
  end

  def active_subscription_end_date
    return nil if !self.subscription || !self.subscription.active?
    return next_billing_date
  end

  def first_billing_date
    first_subscription.start_date.to_date if first_subscription
  end

  def first_billing_amount
    first_subscription.starting_amount if first_subscription
  end

  def first_subscription
    subscriptions.order('created_at ASC').first
  end

  def latest_billing_amount
    payments.last.try(:amount)
  end

  def subscription
    subscriptions.last
  end

  def status
    @status ||= OrganizationStatus.new(self, subscription)
  end

  def billing_emails
    subscription.try(:billing_email).presence || executives.pluck(:email)
  end

  def days_left_until_rebill
    (next_billing_date - Time.zone.today).to_i if next_billing_date
  end

  def extend_next_billing_date!
    update_attribute(:next_billing_date, extended_next_billing_date)
  end

  def extended_next_billing_date
    (next_billing_date ? next_billing_date : Time.zone.today) + 365
  end

  def payment_method_expired?
    active_subscription &&
      active_subscription.payment_method_expires_before?(Time.zone.now.to_date)
  end

  def payment_method_expires_before_next_billing_date?
    next_billing_date &&
      active_subscription &&
      active_subscription.payment_method_expires_before?(next_billing_date)
  end

  def account_status
    active ? 'active' : (subscription ? 'inactive' : 'needs approval')
  end

  def cancel_subscriptions(options)
    subscriptions.active.where('id <> ?', options[:except]).
      find_each(&:cancel)
  end

  def create_subscription_event(attrs)
    subscription_events.create(attrs)
  end

  def self.send_renewal_reminders
    [30, 15].each do |days|
      renewing_in(days).find_each do |org|
        org.send_renewal_reminder
      end
    end
  end

  def send_renewal_reminder
    BillingMailer.renewal_reminder(self).deliver_now
  end

  def self.send_credit_card_expiration_notices
    credit_card_expiring_this_month.find_each do |org|
      org.send_credit_card_expiration_notice
    end
  end

  def send_credit_card_expiration_notice
    BillingMailer.credit_card_expiration(self).deliver_now
  end

  def update_salesforce
    SalesforceClient.new.upsert_account(self)
  end

  private
   
  def send_admin_notification
    logger.debug("Sending sign_up email for organization #{name}")
    User.admins.each do |admin|
      logger.debug("Trying to send to #{admin.email}")
      AdminMailer.new_organization(self,admin).deliver_now rescue logger.debug("send org notification to admin email failed")
    end
  end

  def send_approval_email
    logger.debug("Sending approval email for organization #{name}")
    OrganizationMailer.approved(self).deliver_now rescue logger.debug("send approval email failed")
  end
  
  def setup_initial_todo
    logger.debug("setup_initial_todo: #{self.todos.count}")
    self.todos.create(:critical_function => 'people', :description => "adding a second manager through the Settings menu to ensure your organization's access to the ArtsReady site", :priority => 'critical', :user => users.first, :due_on => Time.zone.today) if self.todos.count == 0
  end

end
