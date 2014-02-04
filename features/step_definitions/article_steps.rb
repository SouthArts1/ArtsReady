module ArticleHelpers
  def fill_out_article_form(params = {})
    params = params.reverse_merge(
      :title => 'this is a test',
      :description => 'this is only a test',
      :body => 'this is not an actual emergency')
    params.each do |attr, value|
      fill_in "article[#{attr}]", :with => value
    end
    select 'People', :from => 'article[critical_function]'
  end
end
World(ArticleHelpers)

When /^I view the article page for "([^"]*)"$/ do |title|
  article = Article.find_by_title(title)
  visit article_path(article)
end

Given /^(.*) has shared the article "(.*)" with me$/ do |org, title|
  article = Organization.find_by_name(org).articles.find_by_title(title)
  article.update_attributes!(
    :visibility => 'shared', 
    :buddy_list => @current_user.organization.id.to_s)
end

Then /^I should(?: still)? be able to view the "([^"]*)" article$/ do |title|
  step %{I view the article page for "#{title}"}
  page.should have_content(title)
end

Then /^the "(.*)" article should(?: still)? be in the public library$/ do |title|
  be_on 'the public library page'
  fill_in 'term', :with => title
  click_button 'Search library'

  click_link title
end

Then /^I should see the Battle Buddy article icon$/ do
  page.should have_selector(".icon img[alt='Battle Buddy']")
end

Then /^I should see the critical article icon$/i do
  page.should have_selector(".icon img[alt='Critical']")
end

Then /^I should see no article icons$/ do
  page.should_not have_selector(".icon img[alt='Battle Buddy']")
  page.should_not have_selector(".icon img[alt='Critical']")
end

Given /^that article belongs to the organization ([^"]*)$/ do |org|
  org_id = Organization.find_by_name(org).id
  Article.last.update_attribute(:organization_id, org_id)
end
