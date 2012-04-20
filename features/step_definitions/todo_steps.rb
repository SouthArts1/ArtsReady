Given /^I have created a todo item$/ do
  @current_todo = Factory.create(:todo,
    :user => @current_user, :organization => @current_user.organization)
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
      row.all('td').values_at(*columns).map(&:text).map(&:strip)
    end

    table.diff!([table.headers, *actual_cells])
  end
end
