module BraintreeCustomerConcern
  extend ActiveSupport::Concern

  include Braintree

  attr_accessor :last_braintree_result

  # Create a customer on Braintree, and store their id against the record
  #
  # @return Boolean
  def create_braintree_customer
    raise "Braintree customer #{payment_vault_id} exists" unless payment_vault_id.blank?

    result = Braintree::Customer.create(
      :first_name => first_name,
      :last_name => last_name,
      :email => email,
      :phone => phone
    )
    if result.success?
      self.payment_vault_id = result.customer.id
      true
    else
      false
    end
  end

  # Find a braintree customer based on their vault ID
  def braintree_customer
    return nil unless payment_vault_id

    @braintree_customer ||= Braintree::Customer.find(payment_vault_id)
  end

  def payment_methods
    return [] unless braintree_customer
    @payment_methods ||= braintree_customer.payment_methods
  end

  def default_payment_method
    payment_methods.find(&:default?)
  end

  def save_payment_method_stub!(payment_method)
    payment_method_stubs.create!(label: "#{payment_method.card_type} ending in #{payment_method.last_4}", vault_token: payment_method.token, default: payment_method.default?, vault_expiry: Date.strptime("{ #{payment_method.expiration_year}, #{payment_method.expiration_month}, 01 }", "{ %Y, %m, %d }"))
  end

  def remove_payment_method_stub!(payment_method)
    payment_method_stubs.where(vault_token: payment_method.token).delete
  end
end
