class Admin::DiscountCodesController < Admin::AdminController
  def index
    @discount_codes = DiscountCode.all
  end
  
  def new
    @discount_code = DiscountCode.new
  end
  
  def create
    if @discount_code = DiscountCode.create(params[:discount_code])
      redirect_to admin_discount_codes_path, notice: "Your discount code has been successfully created!"
    else
      @discount_code = DiscountCode.new(params[:discount_code])
      redirect_to :back, notice: "Something went wrong, please try again."
    end
  end
  
  def edit
    @discount_code = DiscountCode.find(params[:id])
  end
  
  def update
    @discount_code = DiscountCode.find(params[:id])
    
    if @discount_code.update_attributes(params[:discount_code])
      redirect_to admin_discount_codes_path, notice: "That code was successfully updated!"
    else
      redirect_to :back, notice: "There was a problem updating that discount code.  Please try again!"
    end
  end
  
end