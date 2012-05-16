class PaymentVariablesController < ApplicationController
  # GET /payment_variables
  # GET /payment_variables.xml
  def index
    @payment_variables = PaymentVariable.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @payment_variables }
    end
  end

  # GET /payment_variables/1
  # GET /payment_variables/1.xml
  def show
    @payment_variable = PaymentVariable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @payment_variable }
    end
  end

  # GET /payment_variables/new
  # GET /payment_variables/new.xml
  def new
    @payment_variable = PaymentVariable.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @payment_variable }
    end
  end

  # GET /payment_variables/1/edit
  def edit
    @payment_variable = PaymentVariable.find(params[:id])
  end

  # POST /payment_variables
  # POST /payment_variables.xml
  def create
    @payment_variable = PaymentVariable.new(params[:payment_variable])

    respond_to do |format|
      if @payment_variable.save
        format.html { redirect_to(@payment_variable, :notice => 'Payment variable was successfully created.') }
        format.xml  { render :xml => @payment_variable, :status => :created, :location => @payment_variable }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @payment_variable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /payment_variables/1
  # PUT /payment_variables/1.xml
  def update
    @payment_variable = PaymentVariable.find(params[:id])

    respond_to do |format|
      if @payment_variable.update_attributes(params[:payment_variable])
        format.html { redirect_to(@payment_variable, :notice => 'Payment variable was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @payment_variable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_variables/1
  # DELETE /payment_variables/1.xml
  def destroy
    @payment_variable = PaymentVariable.find(params[:id])
    @payment_variable.destroy

    respond_to do |format|
      format.html { redirect_to(payment_variables_url) }
      format.xml  { head :ok }
    end
  end
end
