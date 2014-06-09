class BillingInfoTestPage < TestPage
  # attr_accessor :page
  attr_accessor :missing_info

  # def initialize(page)
  #   self.page = page
  # end

  def missing_billing_info
    [
      'My Org',
      'Bill Lastname',
      '100 Test St',
      'New York, NY 10001',
      'Credit Card',
      '555-555-1212'
    ].select do |text|
      page.has_no_content?(text)
    end
  end

  def arb_id
    $1 if page.body =~ /Authorize.Net subscription ID:\s+([0-9]+)/
  end
end
