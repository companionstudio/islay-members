module IslayMembers
  module Admin
    class MembersController < ApplicationController
      resourceful :member
      header 'Members'
      nav_scope :club

      def index
        @members = Member.includes(:active_subscription, :default_address).page(params[:page]).filtered(params[:filter]).sorted(params[:sort])
      end

      def delete
      end

      private

      def redirect_for(model)
        path(:edit, model)
      end

      def dependencies
        prepare_for_editing if editing? or creating?
      end

      def prepare_for_editing
        @member.addresses.build
      end
    end
  end
end
