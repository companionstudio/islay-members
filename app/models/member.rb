class Member < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :validatable, :registerable, :rememberable, :confirmable

  ACTIVE_USER_STATUSES = ['active'].freeze
  INACTIVE_USER_STATUSES = ['inactive', 'cancelled'].freeze
  USER_STATUSES = (ACTIVE_USER_STATUSES + INACTIVE_USER_STATUSES).freeze

  validations_from_schema

  include PgSearch
  multisearchable :against => [:name, :email]

  has_many :addresses

  has_one :default_address, -> {where(:default => true)}

  has_many :payment_methods
  has_one  :default_payment_method, -> {where(:default => true)}, class_name: 'PaymentMethod'

  has_many :member_orders
  has_many :orders, through: :member_orders
  has_many :offer_orders, through: :orders
  has_many :offers, through: :offer_orders


  accepts_nested_attributes_for :addresses, reject_if: proc {|a| a[:street].blank? and a[:postcode].blank?}
  accepts_nested_attributes_for :payment_methods, reject_if: proc {|a| a[:provider].blank?}

  def self.filtered(filter)
    case filter
    when 'all' then all
    when 'disabled' then where.not(:status => ACTIVE_USER_STATUSES)
    else where(:status => ACTIVE_USER_STATUSES)
    end
  end

  def self.active
    where(:status => ACTIVE_USER_STATUSES)
  end

  def self.with_payment_method
    includes(:payment_methods).where.not(payment_methods: {id: nil})
  end

  def self.member_status_options
    @member_status_options ||= USER_STATUSES.map do |t|
      [t.humanize, t]
    end
  end

  # Returns a scope that sorts the results by the provided field. This behaves
  # close to ::order except that it defaults to sorting by :name.
  #
  # @param [String, nil] sort
  def self.sorted(sort)
    order(sort || :name)
  end

  def billing_address
    addresses.count == 1 ? addresses.first : addresses.find_by(type: 'billing')
  end

  def shipping_address
    addresses.count == 1 ? addresses.first : addresses.find_by(type: 'shipping')
  end

  def destroyable?
    true
  end

  def active?
    status.in? ACTIVE_USER_STATUSES
  end

  private

  # This is a tweaked version of Devise's implementation of this method. We
  # inject an extra condition to restrict the results to records that are not
  # disabled.
  #
  # @return [User, nil]
  def self.find_for_database_authentication(conditions)
    find_for_authentication(conditions.merge('status' => ACTIVE_USER_STATUSES))
  end

  protected

  # This overwrites the default implementation provided by
  # Devise::Models::Validatable. It ignores blanks strings.
  #
  # @return [true, false]
  def password_required?
    !persisted? || !password.blank? || !password_confirmation.blank?
  end
end
