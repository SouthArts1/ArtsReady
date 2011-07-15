require 'spec_helper'

describe Need do
  it { should belong_to(:crisis)}
  it { should belong_to(:user)}
  it { should belong_to(:organization)}
end
