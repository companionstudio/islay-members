class IslayMembers::Public::MemberPaymentMethodController < IslayMembers::Public::ApplicationController
  before_action :authenticate_member!
  before_filter :generate_braintree_token, except: [:index, :show]
  before_filter :find_resource, except: [:index, :new, :create]

  def index
  end

  def new
  end

  def show

  end

  def edit
  end

  def create
    unless current_member.payment_vault_id
      current_member.create_braintree_customer
      current_member.save
    end

    result = Braintree::PaymentMethod.create(customer_id: current_member.payment_vault_id, payment_method_nonce: params['payment_method_nonce'])

    if result.success?
      current_member.save_payment_method_stub!(result.payment_method)

      flash[:result] = 'Payment method saved'
      redirect_to public_member_payment_path(id: result.payment_method.token)
    else
      flash[:result] = "We couldn't save your card details"
    end
  end

  def update
    persist! @payment_method
  end

  def destroy
    if @payment_method
      result = @payment_method.delete
      if result
        flash[:result]  = 'Payment method removed'
        redirect_to([:public, :member_payment, :index])
      else
        redirect_to([:edit, :public, :member, @payment_method])
      end
    end
  end

  private

  def persist!(payment_method)

  end

  def generate_braintree_token
    @braintree_token = Braintree::ClientToken.generate
  end

  def find_resource
    @payment_method = current_member.payment_methods.find{|pm|pm.token == params[:id]}
    unless @payment_method
      flash[:result]  = "The payment method requested couldn't be found"
      redirect_to([:public, :member_payment, :index])
    end
  end

  def new_resource

  end
end
