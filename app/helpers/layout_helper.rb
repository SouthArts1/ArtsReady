# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def money_from_cents(cents, free="")
    return cents if cents.to_s.include?("%")
    return "$0.00" if cents == 0 || cents.nil? || cents.is_a?(String)
    return cents if cents.to_s.include?("%")
    number_to_currency (cents.to_f / 100)
  end

  def cf_tab_class(cf)
    if params[:tab] == cf
      'active'
    elsif Todo.for_critical_function(cf).empty?
      'assessment-na'
    else
      nil
    end
  end
end
