class MemberController < ApplicationController
  
  before_filter :authenticate!
  before_filter :load_org
  
  def index
  end
  
end
