module World
  module Accesses::Access
    module Domain
      # @section helpers
      #
      def access_for(patient)
        Renalware::Accesses::Access.for_patient(patient).first_or_initialize
      end

      def valid_access_attributes(patient)
        {
          patient: patient,
          formed_on: Time.zone.today,
          type: Renalware::Accesses::Type.first,
          side: :left
        }
      end

      # @section set-ups
      #
      def set_up_access_for(patient, user:)
        Renalware::Accesses::Access.create!(
          valid_access_attributes(patient).merge(
            site: Renalware::Accesses::Site.first,
            by: user
          )
        )
      end

      # @section commands
      #
      def create_access(patient:, user:, site:)
        Renalware::Accesses::Access.create(
          valid_access_attributes(patient).merge(
            site: site,
            by: user
          )
        )
      end

      def update_access(patient:, user:)
        travel_to 1.hour.from_now

        access = access_for(patient)
        access.update_attributes!(
          updated_at: Time.zone.now,
          started_on: Time.zone.today,
          by: user
        )
      end

      # @section expectations
      #
      def expect_access_to_exist(patient)
        expect(Renalware::Accesses::Access.for_patient(patient)).to be_present
      end

      def expect_access_to_be_refused
        expect(Renalware::Accesses::Access.count).to eq(0)
      end
    end


    module Web
      include Domain

      def create_access(user:, patient:, performed_on:)
        login_as user
        visit patient_hd_dashboard_path(patient)
        within_fieldset "Latest Accesses Accesss" do
          click_on "Add a session"
        end

        fill_in "Access Start Time", with: "13:00"
        select hd_unit.to_s, from: "Hospital Unit"
        fill_in "Access Date", with: I18n.l(performed_on)

        within ".top" do
          click_on "Create"
        end
      end

      def update_access(patient:, user:)
        login_as user
        visit patient_hd_dashboard_path(patient)
        within_fieldset "Latest Accesses Accesss" do
          click_on "Sign Off"
        end

        fill_in "Access End Time", with: "16:00"

        within ".top" do
          click_on "Save"
        end
      end
    end
  end
end
