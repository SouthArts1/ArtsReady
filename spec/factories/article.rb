Factory.define :article do |f|
  f.title 'My Article'
  f.description Forgery::LoremIpsum.sentence
  f.body Forgery::LoremIpsum.paragraphs(3)
  f.visibility 'private'
end

Factory.define :public_article, :parent => :article do |f|
  f.visibility 'public'
end

Factory.define :featured, :parent => :article do |f|
  f.visibility 'public'
  f.featured true
end

Factory.define :article_with_link, :parent => :article do |f|
  f.link "http://www.test.host"
end

Factory.define :article_with_file, :parent => :article do |f|
end