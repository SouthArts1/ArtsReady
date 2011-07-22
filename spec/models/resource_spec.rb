require 'spec_helper'

describe Resource do
  it { should belong_to(:organization) }
  it { should validate_presence_of(:name)}
  it { should validate_presence_of(:details)}
end
