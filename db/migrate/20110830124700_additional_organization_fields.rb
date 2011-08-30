class AdditionalOrganizationFields < ActiveRecord::Migration
  def self.up
    add_column :organizations, :fax_number, :string
    add_column :organizations, :mailing_address, :string
    add_column :organizations, :mailing_address_additional, :string
    add_column :organizations, :address_additional, :string
    add_column :organizations, :mailing_city, :string
    add_column :organizations, :mailing_state, :string
    add_column :organizations, :mailing_zipcode, :string
    add_column :organizations, :parent_organization, :string
    add_column :organizations, :subsidizing_organization, :string
    add_column :organizations, :organizational_status, :string
    add_column :organizations, :operating_budget, :string
    add_column :organizations, :ein, :string
    add_column :organizations, :duns, :string
    add_column :organizations, :nsic_code, :string
    
    add_column :users, :title, :string
    add_column :users, :phone_number, :string
    add_column :users, :accepted_terms, :boolean, :default => true
    
    Organization.all.each {|o| o.update_attributes({:organizational_status => 'UNKNOWN', :operating_budget => 'UNKNOWN'})}
    User.all.each {|u| u.update_attributes({:title => 'TITLE'})}
    
    Page.create(:title => 'Privacy Policy', :body => "we will keep your content private", :slug => 'privacy')
    Page.create(:title => 'Terms of Use', :body => "we will not abuse your information", :slug => 'terms')
    
  end

  def self.down
    remove_column :users, :phone_number
    remove_column :users, :accepted_terms
    remove_column :users, :title
    remove_column :organizations, :address_additional
    remove_column :organizations, :mailing_address_additional
    remove_column :organizations, :nsic_code
    remove_column :organizations, :duns
    remove_column :organizations, :ein
    remove_column :organizations, :operating_budget
    remove_column :organizations, :organizational_status
    remove_column :organizations, :subsidizing_organization
    remove_column :organizations, :parent_organization
    remove_column :organizations, :mailing_zipcode
    remove_column :organizations, :mailing_state
    remove_column :organizations, :mailing_city
    remove_column :organizations, :mailing_address
    remove_column :organizations, :fax_number
  end
end