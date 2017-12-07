module BraintreeCustomerConcern
  extend ActiveSupport::Concern

  include Braintree

  attr_accessor :last_braintree_result

  # Create a customer on Braintree, and store their id against the record
  #
  # @return Boolean
  def create_braintree_customer
    raise "Braintree customer #{payment_vault_id} exists" unless payment_vault_id.blank?

    last_braintree_result = Braintree::Customer.create(
      :first_name => first_name,
      :last_name => last_name,
      :last_name => last_name,
      :email => email,
      :phone => phone
    )
    if last_braintree_result.success?
      payment_vault_id = result.customer.id
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
end
