module ApplicationHelper
  def logged_in?
    not %w(home login join).include?(controller.action_name)
  end
end
