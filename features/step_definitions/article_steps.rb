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

