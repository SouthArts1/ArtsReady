module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
      when /^the home\s?page$/
        '/'
      when /^(?:the|my) dashboard( page)?$/
        '/member/index'
      when /^the todo item$/
        todo_path(@current_todo)
      when /^the public library page$/
        readiness_library_path
      when /^the crisis console$/
        crisis_path(Crisis.first)
      when /^the profile page$/
        buddies_profile_path
      when /^the new article page$/
        new_article_path
      when /^the article page$/
        article_path(@current_article)
      when /^the "(.*)" articles page$/i
        organization_articles_path(@current_user.organization, :critical_function => $1)
      when /^the our buddies page$/i
        buddies_path
      when /^the assessment$/i
        assessment_path
      when /^the lend-a-hand page$/i
        lend_a_hand_path
      when /^the library$/i
        library_path

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))
    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end

  def be_on(page)
    path = path_to(page) rescue url_for(page)
    visit path unless current_path == path
  end
end

World(NavigationHelpers)
