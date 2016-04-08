module World
  module Patients
    module Domain
      def expect_patient_to_be_created(expected_attributes)
        patient = fetch_patient_by_local_id(expected_attributes.fetch("local_patient_id"))

        expected_attributes.each do |attribute_name, expected_value|
          actual_value = patient.send(attribute_name).to_s
          expect(actual_value).to eq(expected_value)
        end
      end

      def fetch_patient_by_local_id(local_id)
        Renalware::Patient.find_by(local_patient_id: local_id)
      end
    end
  end
end