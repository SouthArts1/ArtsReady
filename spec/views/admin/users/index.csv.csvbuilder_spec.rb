require 'spec_helper'

describe "admin/users/index.csv.csvbuilder" do
  let(:paid_org) { FactoryGirl.build_stubbed(:paid_organization) }
  let(:paid_user) { FactoryGirl.build(:paid_user, organization: paid_org) }
  let(:unpaid_user) { FactoryGirl.build(:unpaid_user) }

  before do
    users = double
    users.stub(:includes).and_return(users)
    users.stub(:find_each).
      and_yield(unpaid_user).
      and_yield(paid_user)

    assign :users, users

    render
  end

  let(:csv) { CSV.parse(rendered) }

  it 'renders a header row, and a data row for each user' do
    expect(csv.length).to eq 3
  end

  it 'creates a cell for every row of every column' do
    headers, unpaid_cells, paid_cells = csv
    columns = headers.length

    expect(unpaid_cells.length).to eq(columns)
    expect(paid_cells.length).to eq(columns)
  end
end
