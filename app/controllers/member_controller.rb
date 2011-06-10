class MemberController < ApplicationController
  
  before_filter :authenticate!

end
