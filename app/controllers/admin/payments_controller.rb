class Admin::PaymentsController < Admin::AdminController
  before_filter :find_organization

  def index
  end

  def new
    @payment = @organization.payments.build
  end

  private

  def find_organization
    @organization = Organization.find(params[:organization_id])
  end
end
