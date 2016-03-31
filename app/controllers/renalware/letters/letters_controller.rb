require_dependency "renalware/letters"
require "smart_delegator"

module Renalware
  module Letters
    class LettersController < Letters::BaseController
      before_filter :load_patient

      def index
        @letters = CollectionPresenter.new(@patient.letters, LetterPresenter)
      end

      def new
        @letter = LetterFormPresenter.new(LetterFactory.new(@patient).build)
      end

      def create
        letter = DraftLetter.new(LetterFactory.new(@patient).build).call(letter_params)

        if letter.persisted?
          redirect_to patient_letters_letters_path(@patient),
            notice: t(".success", model_name: "Letter")
        else
          @letter = LetterFormPresenter.new(letter)
          flash[:error] = t(".failed", model_name: "Letter")
          render :new
        end
      end

      def show
        @letter = LetterPresenter.new(@patient.letters.find(params[:id]))
      end

      def edit
        @letter = LetterFormPresenter.new(@patient.letters.find(params[:id]))
        refresh_letter(@letter) # Remove when wisper is used
      end

      def update
        letter = @patient.letters.find(params[:id])
        letter = DraftLetter.new(letter).call(letter_params)

        if letter.valid?
          redirect_to patient_letters_letters_path(@patient),
            notice: t(".success", model_name: "Letter")
        else
          @letter = LetterFormPresenter.new(letter)
          flash[:error] = t(".failed", model_name: "Letter")
          render :edit
        end
      end

      private

      def letter_params
        params
          .require(:letters_letter)
          .permit(attributes)
          .merge(by: current_user)
      end

      def attributes
        [
          :letterhead_id, :author_id, :description, :issued_on,
          :salutation, :body, :notes,
          main_recipient_attributes: main_recipient_attributes,
          cc_recipients_attributes: cc_recipients_attributes
        ]
      end

      def main_recipient_attributes
        [
          :id, :name, :source_type, :source_id,
          address_attributes: address_attributes
        ]
      end

      def cc_recipients_attributes
        [
          :id, :name, :source_type, :source_id, :_destroy,
          address_attributes: address_attributes
        ]
      end

      def address_attributes
        [:id, :street_1, :street_2, :city, :county, :postcode, :country, :_destroy]
      end

      def refresh_letter(letter)
        RefreshLetter.new(letter).call
      end
    end
  end
end