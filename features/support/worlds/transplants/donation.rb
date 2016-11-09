module World
  module Transplants::Donation
    module Domain
      # @section helpers
      #
      def donation_for(patient)
        patient = transplant_patient(patient)

        Renalware::Transplants::Donation.for_patient(patient).first_or_initialize
      end

      def valid_donation_attributes
        {
          state: :volunteered,
          relationship_with_recipient: :son_or_daughter
        }
      end

      # @section seeding
      #
      def seed_donation(patient)
        patient = transplant_patient(patient)

        Renalware::Transplants::Donation.create!(
          valid_donation_attributes.merge(
            patient: patient
          )
        )
      end

      # @section commands
      #
      def create_donation(patient:, user:, state: nil)
        patient = transplant_patient(patient)

        Renalware::Transplants::Donation.create(
          valid_donation_attributes.merge(
            patient: patient,
            state: state
          )
        )
      end

      def update_donation(patient:, user: nil)
        travel_to 1.hour.from_now

        donation = donation_for(patient)
        donation.update_attributes!(
          updated_at: Time.zone.now
        )
      end

      def assign_recipient_to_donation(patient:, recipient:, user: nil)
        donation = donation_for(patient)
        donation.update_attributes!(
          recipient_id: recipient.id
        )
      end

      # @section expectations
      #
      def expect_donation_to_exist(patient)
        expect(Renalware::Transplants::Donation.for_patient(patient)).to be_present
      end

      def expect_update_donation_to_succeed(patient:, user:)
        update_donation(patient: patient, user: user)
        donation = donation_for(patient)
        expect(donation).to be_modified
      end

      def expect_donation_to_be_refused
        expect(Renalware::Transplants::Donation.count).to eq(0)
      end

      def expect_transplant_donation_as_recipient(patient:, recipient:)
        donation = donation_for(patient)
        expect(donation.recipient_id).to eq(recipient.id)
      end
    end


    module Web
      include Domain

      def create_donation(user:, patient:, state: nil)
        login_as user
        visit patient_transplants_donor_dashboard_path(patient)
        click_on "Enter donation"

        begin
          find("option[value='#{state}']").select_option
          select "Son or daughter", from: "Relationship With Recipient"
        rescue Capybara::ElementNotFound
        end

        within ".top" do
          click_on "Save"
        end
      end

      def update_donation(patient:, user:)
        login_as user
        visit patient_transplants_donor_dashboard_path(patient)
        within_fieldset "Donation" do
          click_on "Edit"
        end

        select "Seen in Clinic", from: "State"

        within ".top" do
          click_on "Save"
        end
      end

      def assign_recipient_to_donation(patient:, recipient:, user:)
        login_as user
        visit patient_transplants_donor_dashboard_path(patient)
        within_fieldset "Donation" do
          click_on "Edit"
        end

        fill_autocomplete "form.simple_form", "recipient_auto_complete",
          with: "ThePatient", select: "Patty"

        within ".top" do
          click_on "Save"
        end
      end
    end
  end
end
