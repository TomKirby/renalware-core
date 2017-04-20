require "active_support/concern"

module Renalware
  module Concerns::Pageable
    extend ActiveSupport::Concern

    included do
      attr_reader :page, :per_page

      def prepare_paging
        @page = params[:page]
        @per_page = params[:per_page]
      end
    end
  end
end
