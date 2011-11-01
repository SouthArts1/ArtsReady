class MemberController < ApplicationController

  def index
    redirect_to crisis_path(current_org.crisis) if current_org.declared_crisis?
    @crises =  Crisis.shared_with_the_community + Crisis.shared_with_my_battle_buddy_network(current_org.battle_buddy_list) + Crisis.shared_with_me(current_org)
    
    @todos = current_org.todos
  end
  
  def library
    @critical_function_counts = Article.for_public.group(:critical_function).count
    @public_articles = Article.for_public
    @public_comments = Comment.for_public.recent
    @our_comments = current_org.comments.recent
  end

end