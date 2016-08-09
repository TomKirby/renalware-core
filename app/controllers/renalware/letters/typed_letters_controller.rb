require_dependency "renalware/letters"

module Renalware
  module Letters
    class TypedLettersController < Letters::BaseController
      before_filter :load_patient

      def create
        letter = @patient.letters.draft.find(params[:letter_id])
        typed_letter = letter.typed(by: current_user)
        typed_letter.save!

        redirect_to patient_letters_letter_path(@patient, typed_letter), notice: t(".success")
      end
    end
  end
end