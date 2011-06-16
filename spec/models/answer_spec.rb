require 'spec_helper'

describe Answer do
  it { should belong_to(:assessment) }
end
