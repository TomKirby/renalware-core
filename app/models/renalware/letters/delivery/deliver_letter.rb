require "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    module Delivery
      # Responsible for delivering the letter according to the recipient's preferred method:
      # - Email letter to practice if GP is a recipient and the practice has an email address;
      # - Currently no other action taken, but this class could be extended to for example to
      #   email the letter contacts who wanted it delivered that way etc.
      class DeliverLetter
        pattr_initialize [:letter!]
        delegate :email_letter_to_practice?, :gp_recipient, to: :policy

        def call
          if email_letter_to_practice?
            email_letter_to_the_patients_practice_and_flag_as_sent
          end
        end

        private

        def email_letter_to_the_patients_practice_and_flag_as_sent
          Letter.transaction do
            mail = PracticeMailer.patient_letter(letter: letter, to: practice_email_address)
            mail.deliver_later
            gp_recipient.update(emailed_at: Time.zone.now)
          end
        end

        def practice_email_address
          PracticeEmail.new(letter).address
        end

        def policy
          @policy ||= DeliveryPolicy.new(letter)
        end
      end
    end
  end
end
