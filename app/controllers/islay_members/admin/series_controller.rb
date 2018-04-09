module IslayMembers
  module Admin
    class SeriesController < ApplicationController
      resourceful :series
      header 'Series'
      nav_scope :club

      def index
        @series = Series.filtered(params[:filter])
      end

      def delete
      end

      private

      def redirect_for(model)
        path(:series)
      end

      def dependencies
        prepare_for_editing if editing? or creating?
      end

      def prepare_for_editing
      end
    end
  end
end
