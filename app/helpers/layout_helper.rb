# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def money_from_cents(cents)
    return cents if cents.to_s.include?("%")
    return "$0.00" if cents == 0 || cents.nil? || cents.is_a?(String)
    number_to_currency (cents.to_f / 100)
  end

  def rfc822_time(time)
    time.try(:to_s, :rfc822)
  end
end