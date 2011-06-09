require File.dirname(__FILE__) + '/../spec_helper'

describe Article do
  subject { Article.new }
  
  it { should belong_to(:user) }
  it { should belong_to(:organization) }
  
  it { should validate_presence_of(:title) } 
  it { should validate_presence_of(:content) }

end
