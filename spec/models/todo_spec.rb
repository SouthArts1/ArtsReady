require 'spec_helper'

describe Todo do
  it { should belong_to(:answer) }
  it { should belong_to(:action_item) }
  it { should belong_to(:organization) }
end