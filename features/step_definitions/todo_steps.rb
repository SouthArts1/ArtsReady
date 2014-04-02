module TodoStepHelper
  def go_to_todo(label)
    click_link 'To-Do'
    within find('tr', :text => Regexp.new(Regexp.quote(label))) do
      click_link 'Details'
    end
  end

  def my_todo_emails
    unread_emails_for(@current_user.email).
      select { |message| message.subject =~ /to-?do/i }
  end
end
World(TodoStepHelper)

Given /^I have created a todo item$/ do
  @current_todo = Factory.create(:todo,
    :user => @current_user, :organization => @current_user.organization)
end

Given /^I have created the following to-?do items:$/ do |table|
  table.hashes.each do |human_hash|
    attributes = 
      convert_human_hash_to_attribute_hash(human_hash, 
        FactoryGirl.factory_by_name(:todo).associations)
    todo = @current_user.organization.todos.build(attributes)
    todo.save!
  end
end

Given /^I (?:complete|have completed) the "([^"]*)" todo$/ do |label|
  go_to_todo(label)
  check 'Completed?'
  click_button 'Save and Return to List'
end

When /^I add an article titled "(.*)" to the todo item$/ do |title|
  be_on todo_path(@current_todo)
  click_link "Add an Article"
  fill_out_article_form(:title => title)
  click_button 'Save'
  @current_article = Article.last
end

Then /^I should see (\d+) todos$/ do |count|
  page.should have_css('td.item', :count => count.to_i)
end

Then /^I should not see any todos$/ do
  page.should_not have_css('item')
end

Then /^I should see the following todos:$/ do |table|
  within 'table.actionitems' do
    actual_headers = all('thead th').map(&:text)
    columns = table.headers.map { |header| actual_headers.index(header) }
    actual_cells = all('tbody tr').map do |row|
      row.all('td').to_a.values_at(*columns).map(&:text).map(&:strip)
    end

    table.diff!([table.headers, *actual_cells])
  end
end

Then /^the "([^"]*)" todo should be restarted$/ do |label|
  go_to_todo(label)
  find_field('Completed?')['checked'].should be_false
  find('.log').should have_content('Restarted')
end

Then /^the "([^"]*)" todo's history should be preserved$/ do |label|
  go_to_todo(label)
  find('.log').should have_content('to Complete') # status changed...
end

Given /^I have an overdue todo item$/ do
  @current_user.organization.todos.create!(
    :description => 'Overtodue',
    :due_on => Date.yesterday,
    :user => @current_user,
    :critical_function => 'people',
    :priority => 'critical'
  )
end

Then /^I should receive todo reminders on Tuesdays$/ do
  reset_mailer

  Timecop.travel(Date.today.end_of_week + 2) # a future Tuesday
  step %{the scheduled tasks have run} # Reminder.todos_nearly_due

  emails = my_todo_emails
  emails.last.text_part.body.should =~ /Overtodue/

  reset_mailer

  Timecop.travel(Date.today.end_of_week + 1) # the Monday after that
  step %{the scheduled tasks have run}

  my_todo_emails.should be_empty
end

When /^I complete the overdue todo item$/ do
  step %{I complete the "Overtodue" todo}
end

Then /^I should not receive todo reminders$/ do
  reset_mailer

  Timecop.travel(Date.today.end_of_week + 2) # a future Tuesday
  step %{the scheduled tasks have run} # Reminder.todos_nearly_due

  my_todo_emails.should be_empty
end
