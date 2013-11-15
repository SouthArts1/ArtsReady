require 'spec_helper'

describe DiscountCode do
  subject(:discount_code) { FactoryGirl.build(:discount_code) }

  it { should be_valid }
end
