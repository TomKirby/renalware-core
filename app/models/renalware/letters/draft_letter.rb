require_dependency "renalware/letters"

module Renalware
  module Letters
    class DraftLetter
      include Wisper::Publisher

      def self.build
        new
      end

      def call(patient, params = {})
        letter = LetterFactory.new(patient, params).build
        # Rails.logger.info "Drafting letter of class #{letter.class} with type #{letter.type}"
        letter.save!
        letter.reload
        broadcast(:draft_letter_successful, letter)
      rescue ActiveRecord::RecordInvalid
        broadcast(:draft_letter_failed, letter)
      end
    end
  end
end
