require File.dirname(__FILE__) + '/../spec_helper'

describe Article do
  subject { Article.new }
  
  it { should belong_to(:user) }
  it { should belong_to(:organization) }
  it { should belong_to(:todo) }
  
  it { should validate_presence_of(:title) } 
  it { should validate_presence_of(:description) }

  it { subject.is_public?.should be_false}
  it { subject.is_featured?.should be_false}
  it { subject.on_critical_list?.should be_false}
end
