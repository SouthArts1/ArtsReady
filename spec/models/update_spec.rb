require 'spec_helper'

describe Update do
  it { should belong_to(:crisis)}
  it { should belong_to(:organization)}
  it { should belong_to(:user)}

  it { should validate_presence_of(:crisis_id)}
  it { should validate_presence_of(:organization_id)}
  it { should validate_presence_of(:user_id)}
  it { should validate_presence_of(:message)}

end
