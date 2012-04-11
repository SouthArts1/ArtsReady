require 'spec_helper'

describe "assessments/show" do
  let(:current_org) { Factory.create(:organization) }

  before do
    view.stubs(:current_org).returns(current_org)
    assign :answers, Factory.create_list(:answer, 1)
    assign :critical_function, 'productions'

    render
  end

  it('renders') {}
end

