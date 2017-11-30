class IslayMembers::Public::MemberPaymentMethodController < IslayMembers::Public::ApplicationController
  before_action :authenticate_member!

  def index
  end

  def new
    @braintree_token = Braintree::ClientToken.generate
  end

  def show

  end

  def edit
  end

  def create
    @braintree_token = Braintree::ClientToken.generate
    result = Braintree::PaymentMethod.create(customer_id: current_member.payment_vault_id, payment_method_nonce: params['payment_method_nonce'])

    if result.success?
      flash[:result]  = 'Payment method saved'
      redirect_to public_member_payment_path
    else
      flash[:result]  = "We couldn't save your card details"
    end
  end

  def update
    persist! @payment_method
  end

  def destroy
    if @payment_method.destroy
      flash[:result]  = 'Payment method deleted'
      redirect_to([:public, :member, :payment_method, :index])
    else
      redirect_to([:edit, :public, :member, payment_method])
    end
  end

  private

  def persist!(payment_method)

  end

  def find_resource

  end

  def new_resource

  end
end
