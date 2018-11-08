class MemberOrder < ActiveRecord::Base
  belongs_to :member
  belongs_to :order

  def initialize_order_values!
    order.name              ||= member.name
    order.phone             ||= member.phone
    order.email             ||= member.email

    order.billing_street    ||= member.billing_address.street
    order.billing_city      ||= member.billing_address.city
    order.billing_postcode  ||= member.billing_address.postcode
    order.billing_state     ||= member.billing_address.state
    order.billing_country   ||= member.billing_address.country

    order.shipping_street   ||= member.shipping_address.street
    order.shipping_city     ||= member.shipping_address.city
    order.shipping_postcode ||= member.shipping_address.postcode
    order.shipping_state    ||= member.shipping_address.state
    order.shipping_country  ||= member.shipping_address.country

    nil
  end
end
