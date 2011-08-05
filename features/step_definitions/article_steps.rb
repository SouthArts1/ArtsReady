When /^I view the article page for "([^"]*)"$/ do |title|
  article = Article.find_by_title(title)
  visit article_path(article)
end
