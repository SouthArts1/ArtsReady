Factory.define :article do |f|
  f.title 'My Article'
  f.description 'Test article content'
  f.visibility 'private'
end

Factory.define :public_article, :parent => :article do |f|
  f.visibility 'public'
end

Factory.define :featured, :parent => :article do |f|
  f.visibility 'public'
  f.featured true
end