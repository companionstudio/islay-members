class Address < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  belongs_to :member

  after_initialize :initialize_default, if: :new_record?
  before_save :enforce_single_default

  BASE_ADDRESS_TYPES = %w{billing shipping}.freeze
  FRIENDLY_ADDRESS_TYPES = %w{billing_and_shipping billing shipping}.freeze

  def self.address_type_options
    @address_type_options ||= BASE_ADDRESS_TYPES.map do |t|
      [t.humanize, t]
    end
  end

  def self.friendly_address_type_options
    @friendly_address_type_options ||= FRIENDLY_ADDRESS_TYPES.map do |t|
      [t.humanize, t]
    end
  end

  def self.default
    where(:default => true)
  end

  def friendly_type
    if default?
      'Billing and shipping'
    else
      type.humanize
    end
  end

  def friendly_type=(new_type)
    if new_type == 'billing_and_shipping'
      default = true
      type = 'billing'
    else
      type = new_type
    end
  end

  def siblings
    @siblings ||= member.addresses.where.not(id: self.id)
  end

  def only?
    siblings.empty?
  end

  def address_type_options
    @address_type_options ||= BASE_ADDRESS_TYPES.map do |t|
      [t.humanize, t]
    end
  end

  private

  def initialize_default
    self.default = true unless siblings.present? and siblings.default.present?
  end

  def enforce_single_default
    if !default
      initialize_default
    else
      siblings.update_all(:default => false)
    end
  end
end
