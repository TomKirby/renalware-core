module World
  module PD::Medication
    module Domain
      # @ section commands
      #
      def record_medication_for(treatable:, drug_name:, dose:,
        route_name:, frequency:, starts_on:, provider:, **_)
        drug = Renalware::Drugs::Drug.find_by!(name: drug_name)
        route = Renalware::MedicationRoute.find_by!(name: route_name)

        treatable.medications.create!(
          patient: treatable.patient,
          drug: drug,
          dose: dose,
          medication_route: route,
          frequency: frequency,
          start_date: starts_on,
          provider: provider.downcase
        )
      end

      def revise_medication_for(treatable:, drug_name:)
        drug = Renalware::Drugs::Drug.find_by!(name: drug_name)
        medication = treatable.medications.last!

        medication.update!(drug: drug)
      end

      def terminate_medication_for(treatable:, user:)
        medication = treatable.medications.last!

        medication.destroy
        expect(medication).to be_deleted
      end
    end

    module Web
      include Domain

      # @ section commands
      #
      def record_medication_for(treatable:, drug_name:, dose:, route_name:,
        frequency:, starts_on:, provider:,
        drug_selector: default_medication_drug_selector)

        click_link "Add Medication"
        wait_for_ajax

        within "#new_medication" do
          drug_selector.call(drug_name)
          fill_in "Dose", with: dose
          select(route_name, from: "Route")
          fill_in "Frequency", with: frequency
          fill_in "Prescribed on", with: starts_on
          click_on "Save"
          wait_for_ajax
        end
      end

      def default_medication_drug_selector
        -> (drug_name) { select(drug_name, from: "Select Drug") }
      end

      def revise_medication_for(treatable:, drug_name:)
        within "#medications" do
          click_on "Edit"
        end

        select(drug_name, from: "Select Drug")
        click_on "Save"
        wait_for_ajax
      end
    end

    def terminate_medication_for(treatable:, user:)
      within "#medications" do
        click_on "Terminate"
      end
      wait_for_ajax

      medication = treatable.medications.with_deleted.last!

      expect(medication).to be_deleted
    end
  end
end
