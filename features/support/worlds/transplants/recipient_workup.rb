module World
  module Transplants::RecipientWorkup
    module Domain
      # @section helpers
      #
      def recipient_workup_for(patient)
        Renalware::Transplants::RecipientWorkup.for_patient(patient).first_or_initialize
      end

      # @section set-ups
      #
      def set_up_recipient_workup_for(patient)
        Renalware::Transplants::RecipientWorkup.create!(
          patient: patient
        )
      end

      # @section commands
      #
      def create_recipient_workup(user: nil, patient:)
        set_up_recipient_workup_for(patient)
      end

      def update_workup(patient:, user: nil)
        travel_to 1.hour.from_now

        workup = recipient_workup_for(patient)
        workup.update_attributes!(
          document: {
            historicals: {
              tb: "no"
            }
          },
          updated_at: Time.zone.now
        )
      end

      # @section expectations
      #
      def expect_recipient_workup_to_exist(patient)
        expect(Renalware::Transplants::RecipientWorkup.for_patient(patient)).to be_present
      end

      def expect_workup_to_be_modified(patient)
        workup = Renalware::Transplants::RecipientWorkup.for_patient(patient).first
        expect(workup.updated_at).to_not eq(workup.created_at)
      end
    end


    module Web
      include Domain

      def create_recipient_workup(user:, patient:)
        login_as user
        visit patient_clinical_summary_path(patient)
        click_on "Transplant Recipient Workup"

        fill_in "Karnofsky Score", with: "66"

        within ".top" do
          click_on "Save"
        end
      end

      def update_workup(patient:, user:)
        login_as user
        visit patient_clinical_summary_path(patient)
        click_on "Transplant Recipient Workup"
        click_on "Edit"

        fill_in "Cervical smear result", with: "193"

        within ".top" do
          click_on "Save"
        end
      end
    end
  end
end