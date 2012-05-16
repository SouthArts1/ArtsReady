module AuthorizeNet

  # Models an address.
  class Address
    
    include AuthorizeNet::Model
    
    attr_accessor :first_name, :last_name, :company, :street_address, :city, :state, :zip, :country, :phone, :fax, :customer_address_id, :address_type, :email
    
    def to_hash
      hash = {
        :first_name => @first_name,
        :last_name => @last_name,
        :company => @company,
        :address => @street_address,
        :city => @city,
        :state => @state,
        :zip => @zip,
        :country => @country,
        :phone => @phone,
        :fax => @fax,
        :email => @email,
        :customer_address_id => @customer_address_id
      }
      hash.delete_if {|k, v| v.nil?}
    end
    
  end

end