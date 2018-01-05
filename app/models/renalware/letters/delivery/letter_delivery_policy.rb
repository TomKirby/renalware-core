require_dependency "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    module Delivery
      # A (non-pundit) policy driving logic around whether to email the letter to the practice
      class LetterDeliveryPolicy
        pattr_initialize :letter
        delegate :patient, :recipients, to: :letter
        delegate :practice, to: :patient

        def email_letter_to_practice?
          email = PracticeEmail.new(letter).address
          email.present? && gp_recipient.present?
        end

        def gp_is_a_recipient?
          gp_recipient.present?
        end

        def gp_recipient
          recipients.find(&:primary_care_physician?)
        end
      end
    end
  end
end
