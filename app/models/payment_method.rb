class PaymentMethod < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  belongs_to :member

  BASE_TYPES = %w{visa mastercard american_express}.freeze

  def self.card_type_options
    @card_type_options ||= BASE_TYPES.map do |t|
      [t.humanize, t]
    end
  end
end
