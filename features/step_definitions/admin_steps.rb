Given /^(?:I am signed in as )?a sysadmin$/ do
  email = 'admin@test.host'
  password = 'password'
  @current_user = Factory.create(:sysadmin, :email => email, :password => password)
  login(email,password)
end

Given /^I am a sysadmin with email "([^"]*)"$/ do |email|
  Factory.create(:sysadmin, :email => email)
end

Given /^all users .* "(.*)" are disabled$/ do |org|
  Organization.find_by_name(org).users.
    update_all(:disabled => true)
end

When /^I view the admin article page for "([^"]*)"$/ do |title|
  article = Article.find_by_title(title)
  visit admin_articles_path(article)
end

Then /^I should see the following organizations:$/ do |table|
  table.diff!(
    [
      ['Name', 'Members', 'Assessment %', 'To-Do %'],
      *page.all('table.resource tbody tr').map do |tr|
        ['.name', '.members', '.assessment', '.todo'].map do |selector|
          tr.first(selector).try(:text).try(:strip)
        end
      end
    ]
  )
end

When /^I delete the organization "(.*)"$/ do |org|
  be_on 'the admin organizations page'
  edit_organization(org)

  click_button 'DELETE'
end

Then /^the organization "(.*)" should be deleted$/ do |name|
  be_on 'the admin organizations page'
  page.should_not have_content(name)
end

Given /^organizations with the following states:$/ do |table|
  table.hashes.each do |hash|
    name = hash.fetch('Name')
    active = (hash.fetch('Active') == 'true')
    past_due = hash.fetch('Past Due?') == 'true'
    subscription_factory = {
      'none' => nil,
      'inactive' => :inactive_provisional_subscription,
      'active' => :provisional_subscription
    }.fetch(hash.fetch('Subscription'))

    if subscription_factory
      FactoryGirl.create(:organization, :paid,
        name: name,
        active: active,
        member_count: 1,
        subscription_factory: subscription_factory,
        next_billing_date: past_due ? 5.days.ago : 5.days.from_now
      )
    else
      FactoryGirl.create(:organization,
        name: name,
        active: active
      )
    end
  end
end

Then /^I should see the following organization statuses:$/ do |table|
  names = table.hashes.map { |hash| hash['Name'] }

  table.diff!([
    ['Name', 'Status'],
    *all('table.resource tbody tr').map do |row|
      within row do
        name = find('td.name').text
        status = find('td.status').text

        if names.include? name
          [name, status]
        else
          puts "Organization table also included '#{name}'. (This is probably okay.)"
          nil
        end
      end
    end.compact
  ])

  table.hashes.each do |hash|
    name = hash['Name']
    status = hash['Status']

    within_organization_row(name) do
      expect(find('td.status').text).to eq status
    end
  end
end