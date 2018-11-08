class IslayMembers::Public::MemberOrdersController < IslayMembers::Public::ApplicationController
  before_action :authenticate_member!
  before_action :find_resource, only: [:show, :edit, :update]

  helper IslayMembers::Public::MemberOrdersHelper

  def index
    @orders = current_member.orders
  end

  def show
  end

  def edit
  end

  def update
    persist! @member_order
  end

  private

  def persist!(order)
    if order.update_attributes(params[:order].permit!)
      flash[:result] = 'Order updated'
      redirect_to public_member_order_path(order.reference)
    else
      render :edit
    end
  end

  def find_resource
    @member_order = current_member.orders.find_by(reference: params[:id])
  end

end
