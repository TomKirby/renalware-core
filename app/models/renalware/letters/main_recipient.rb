require_dependency "renalware/letters"

module Renalware
  module Letters
    class MainRecipient < Recipient
      def doctor?
        source_type == "Renalware::Doctor"
      end

      def patient?
        source_type == "Renalware::Patient"
      end
    end
  end
end
