FactoryGirl.define do
  factory :template do
    name 'template name'
    subject 'Subject Template'
    body 'This is the body of the template.'

    factory :renewal_reminder_template do
      name 'renewal reminder'
      subject 'Your ArtsReady subscription will renew in {{days_left_until_rebill}} days'
      body '*Soon* like on {{next_billing_date}}.'
    end

    factory :credit_card_expiration_template do
      name 'credit card expiration'
      subject 'Your ArtsReady credit card will expire in 30 days'
      body 'Please update it before {{next_billing_date}}, {{organization_name}}.'
    end
  end
end