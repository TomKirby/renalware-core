# frozen_string_literal: true

require_dependency "renalware/medications"

module Renalware
  module Medications
    class RouteFormPresenter < DumbDelegator
      def code
        ::I18n.t(
          super.downcase,
          scope: "medications.routes.form.prompt",
          default: super
        )
      end
    end
  end
end
