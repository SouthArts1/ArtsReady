require 'spec_helper'

describe Crisis do
  it { should belong_to(:organization) }
  it { should have_many(:updates) }
  it { should have_many(:needs) }
end
