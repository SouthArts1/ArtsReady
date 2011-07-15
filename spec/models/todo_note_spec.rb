require 'spec_helper'

describe TodoNote do
  it { should belong_to(:todo) }
  it { should belong_to(:user) }
  
  
end
