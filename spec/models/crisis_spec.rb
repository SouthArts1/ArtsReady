require 'spec_helper'

describe Crisis do
  it { should belong_to(:organization) }
  it { should belong_to(:user) }
  it { should have_many(:updates) }
  it { should have_many(:needs) }

  it { should validate_presence_of(:organization_id) }
  it { should validate_presence_of(:user_id) }


end
