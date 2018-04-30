class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include BraintreeCustomerConcern

  devise :database_authenticatable, :recoverable, :validatable, :registerable, :rememberable, :confirmable, :trackable

  ACTIVE_USER_STATUSES = ['active'].freeze
  INACTIVE_USER_STATUSES = ['inactive', 'cancelled'].freeze
  USER_STATUSES = (ACTIVE_USER_STATUSES + INACTIVE_USER_STATUSES).freeze

  validations_from_schema

  # include PgSearch
  # multisearchable :against => [:name, :email]

  has_many :addresses
  has_one :default_address, -> {where(:default => true)}, class_name: 'Address'

  has_many :payment_method_stubs, class_name: 'PaymentMethod' do
    def expired?
      where('vault_expiry < ?', Date.today)
    end

    def expiring?
      where('vault_expiry < ?', Date.today - 30.days)
    end
  end

  has_one  :default_payment_method_stub, -> {where(:default => true)}, class_name: 'PaymentMethod'

  has_many :member_orders
  has_many :orders, through: :member_orders
  has_many :offer_orders, through: :orders
  has_many :offers, through: :offer_orders

  has_one  :subscription
  has_one  :active_subscription, -> {where(:active => true)}, class_name: 'Subscription'
  has_one  :inactive_subscription, -> {where(:active => false)}, class_name: 'Subscription'

  accepts_nested_attributes_for :addresses, reject_if: proc {|a| a[:street].blank? and a[:postcode].blank?}
  # accepts_nested_attributes_for :payment_methods, reject_if: proc {|a| a[:provider].blank?}

  def self.filtered(filter)
    case filter
    when 'all' then all
    when 'disabled' then where.not(:status => ACTIVE_USER_STATUSES)
    when 'subscribed' then subscribed
    else where(:status => ACTIVE_USER_STATUSES)
    end
  end

  def self.complete
    active.with_payment_method.with_address
  end

  def self.active
    where(:status => ACTIVE_USER_STATUSES)
  end

  def self.latest
    active.order('created_at DESC').limit(1).first
  end

  def self.with_payment_method
    includes(:default_payment_method_stub).where.not('payment_methods.id': nil)
  end

  def self.with_address
    includes(:default_address).where.not('addresses.id': nil)
  end

  def self.subscribed
    includes(:active_subscription).where.not('subscriptions.id': nil)
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

  def self.activity(period: 24.hours)
    time_threshold = period.ago
    updated_subscriptions = ::Subscription.where('updated_at > ?', time_threshold)
    created_subscriptions = ::Subscription.where('created_at > ?', time_threshold)
    logins = ::Subscription.where('last_sign_in_at > ?', time_threshold)


  end



  def first_name
    parts = name.split(' ')
    case parts.count
    when 1 then name
    when 2 then parts[0]
    else
      if parts[0].downcase.in? %w{mr mrs miss ms dr}
        parts[1]
      else
        parts[0]
      end
    end
  end

  def last_name
    name.split(' ').last
  end

  def billing_address
    addresses.find_by(type: 'billing') || addresses.first
  end

  def shipping_address
    addresses.find_by(type: 'shipping') || addresses.first
  end

  def destroyable?
    true
  end

  def active?
    status.in? ACTIVE_USER_STATUSES
  end

  def new_member?
    created_at > 2.days.ago
  end

  def complete?
    confirmed? and default_address.present? and default_payment_method.present?
  end

  def subscribed?
    active_subscription.present?
  end

  def soft_delete
    update_attributes(status: 'cancelled', deleted_at: Time.current)
  end

  # ensure user account is active
  def active_for_authentication?
    super && !deleted_at
  end

  # provide a custom message for a deleted account
  def inactive_message
  	!deleted_at ? super : :deleted_account
  end

  # Accessors to make the subscription toggle available via forms
  def subscription_active
    active_subscription.present?
  end

  def subscription_active=(state)
    case state
    when true, 'true', 1, '1'
      if subscription.present?
        subscription.activate!
      else
        create_subscription(active: true)
      end
    else
      subscription.deactivate! if subscription.present?
    end
  end

  private

  # This is a tweaked version of Devise's implementation of this method. We
  # inject an extra condition to restrict the results to records that are not
  # disabled.
  #
  # @return [User, nil]
  def self.find_for_database_authentication(conditions)
    find_for_authentication(conditions.merge('status' => "active"))
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
