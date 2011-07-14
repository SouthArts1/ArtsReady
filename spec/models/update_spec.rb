require 'spec_helper'

describe Update do
  it { should belong_to(:crisis)}
  it { should belong_to(:user)}
  it { should belong_to(:organization)}
end
