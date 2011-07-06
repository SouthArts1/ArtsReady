require 'spec_helper'

describe ActionItem do
  it { should belong_to(:question)}
  it { should have_many(:todos)}
  
  it { should validate_presence_of(:question)}
  it { should_not be_valid }
end
