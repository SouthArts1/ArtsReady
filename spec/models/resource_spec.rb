require 'spec_helper'

describe Resource do
  it { should belong_to(:organization) }
end
