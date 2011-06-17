require 'spec_helper'

describe Question do
  it { should have_many(:action_items) }
end
