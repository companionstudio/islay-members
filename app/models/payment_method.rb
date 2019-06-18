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
    member.payment_methods.reject{|pm|pm.token == token}reject{|pm|pm.expired?}.empty?
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
    binding.pry
    self.default = true if siblings.reject{|pm|pm.expired?}.empty?
  end
end
