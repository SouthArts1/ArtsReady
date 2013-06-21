class MemberController < ApplicationController

  def index
    redirect_to crisis_path(current_org.crisis) if current_org.declared_crisis?
    crises = Crisis.of_active_org
    @crises =  crises.shared_with_the_community +
      crises.shared_with_my_battle_buddy_network(current_org.battle_buddy_list) +
      crises.shared_with_me(current_org)
    @todos = current_user.todos.nearing_due_date + 
      current_user.organization.todos.nearing_due_date.where(:user_id => nil)
    @featured = Article.featured.of_active_orgs
  end
  
  def library
    @public_critical_function_counts = Article.only_public.group(:critical_function).count
    @private_critical_function_counts = current_org.articles.only_private.group(:critical_function).count
    @public_articles = Article.for_public.order('created_at DESC')
    @public_comments = Comment.for_public.recent
    @our_comments = current_org.comments.joins(:article).where("articles.visibility != 'executive'").recent
    @featured = Article.featured.of_active_orgs
  end

end
