class IslayMembers::Public::MemberOfferOrdersController < IslayMembers::Public::ApplicationController
  before_action :authenticate_member!
  before_action :find_resource

  helper IslayMembers::Public::MemberOrdersHelper

  def adjust_offer_order_quantities
    raise "This offer's quantities aren't adjustable" unless @offer.adjustable_quantity?

    quantity = params[:quantity].to_i

    raise "Quantity must be between #{@offer.min_quantity} and #{@offer.max_quantity}" unless (@offer.min_quantity..@offer.max_quantity) === quantity

    new_order = @offer.regenerate_member_order! current_member, quantity

    flash[:result]  = 'Quantities were updated.'
    redirect_to public_member_order_path(new_order.reference)
  end

  def skip_offer_order
    raise "This offer can't be skipped" unless @member_order.offer.skippable?

    @offer.skip! current_member

    flash[:result]  = "You've skipped this offer."
    redirect_to public_member_order_path(@member_order.reference)
  end

  def restore_offer_order
    raise "This offer can't be restored" unless @offer.open?

    new_order = @offer.regenerate_member_order! current_member, @offer.default_quantity

    flash[:result]  = "Great! We've restored your order for this offer."
    redirect_to public_member_order_path(new_order.reference)
  end

  private

  def find_resource
    @member_order = current_member.orders.find_by(reference: params[:id])
    @offer = @member_order.offer
  end

end
