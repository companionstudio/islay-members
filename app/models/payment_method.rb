class PaymentMethod < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  belongs_to :member

  before_create :assign_default

  BASE_TYPES = %w{visa mastercard american_express}.freeze

  def self.card_type_options
    @card_type_options ||= BASE_TYPES.map do |t|
      [t.humanize, t]
    end
  end

  def siblings
    member.payment_method_stubs.reject{|pm|pm.vault_token == vault_token}#.reject{|pm|pm.expired?}
  end

  def expired?
    vault_expiry < Date.today
  end

  def expiring?
    vault_expiry < Date.today + 60.days
  end

  def remote_data
    @remote_data ||= begin
      member.braintree_customer.payment_methods.find{|pm| pm.token == vault_token}
    rescue Braintree::NotFoundError
      []
    end
  end

  private

  # When creating, if this is the only payment method, or the only non-expired payment method,
  # mark as the default
  def assign_default
    siblings.each do |s|
      if s.remote_data
        Braintree::PaymentMethod.update(s.vault_token, options: {make_default: false})
        s.update_column(:default, false)
      else
        # With no remote data, this method has been removed on the gateway. Mark it as dead.
        s.update_columns(default: false, status: 'removed')
      end
    end

    Braintree::PaymentMethod.update(vault_token, options: {make_default: true})
    self.default = true
  end
end
