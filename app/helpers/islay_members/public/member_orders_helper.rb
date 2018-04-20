module IslayMembers
  module Public
    module MemberOrdersHelper
      def offer_order_quantity_range(offer)
        (offer.min_quantity..(offer.max_quantity || 10))
      end
    end
  end
end
