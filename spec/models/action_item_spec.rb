require 'spec_helper'

describe ActionItem do
  it { should belong_to(:question)}
  it { should have_many(:todos)}
end
