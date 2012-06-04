module ArticlesHelper
  def bbn_icon?(article)
    article.organization != current_org && (article.visibility == "shared" || article.visibility =="buddies") ? image_tag('bbn_icon.png', :alt => 'Battle Buddy') : nil
  end
end
