class Member < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :validatable

  ACTIVE_USER_STATUSES = ['active'].freeze

  validations_from_schema

  include PgSearch
  multisearchable :against => [:name, :email]

  has_many :addresses

  has_one :default_address, -> {where(:default => true)}
  has_one :billing_address, -> {where(:type => 'billing')}
  has_one :shipping_address, -> {where(:type => 'shipping')}

  has_many :payment_methods
  has_one  :default_payment_method, -> {where(:default => true)}

  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :payment_methods

  def self.filtered(filter)
    case filter
    when 'all' then all
    when 'disabled' then where.not(:status => ACTIVE_USER_STATUSES)
    else where(:status => ACTIVE_USER_STATUSES)
    end
  end

  # Returns a scope that sorts the results by the provided field. This behaves
  # close to ::order except that it defaults to sorting by :name.
  #
  # @param [String, nil] sort
  def self.sorted(sort)
    order(sort || :name)
  end

  def destroyable?
    true
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
