class Address < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  
  belongs_to :member

  BASE_ADDRESS_TYPES = %w{billing shipping other}.freeze

  def self.address_type_options
    @address_type_options ||= BASE_ADDRESS_TYPES.map do |t|
      [t.humanize, t]
    end
  end

  def self.default
    where(:default => true)
  end
end
