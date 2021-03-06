# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    class ContactDescriptionPresenter < DumbDelegator
      def name
        ::I18n.t(system_code, scope: "renalware.letters.contacts.form.description", default: super)
      end
    end
  end
end
