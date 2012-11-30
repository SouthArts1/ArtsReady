require 'spec_helper'

describe "home/public_articles" do
  let(:critical_function) { 'Important Things' }
  let(:article) {
    Factory.create(:public_article,
      :critical_function => critical_function)
  }
  let(:critical_function_path) {
    public_articles_path(:critical_function => critical_function)
  }

  before do
    assign :public_articles, [article]
    view.stubs(:current_org).returns(nil)

    render
  end

  it 'links to critical function pages' do
    rendered.should have_selector(
      "a[href='#{critical_function_path}']")
  end
end
