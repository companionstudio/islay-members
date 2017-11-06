module IslayMembers
  module Admin
    class MembersController < ApplicationController
      resourceful :member
      header 'Members'
      nav_scope :config

      def index
        @members = Member.page(params[:page]).filtered(params[:filter]).sorted(params[:sort])
      end

      def delete
      end

      private

      def redirect_for(model)
        path(:members)
      end
    end
  end
end
