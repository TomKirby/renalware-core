require_dependency "renalware/doctors"

module Renalware
  module Doctors
    class UpdateDoctor
      include Wisper::Publisher

      def self.build
        SubscriptionRegistry.instance.subscribe_listeners_to(self.new)
      end

      def call(doctor_id, params)
        doctor = find_doctor(doctor_id)

        if doctor.update(params)
          broadcast(:doctor_updated, doctor)
        else
          broadcast(:doctor_update_failed, doctor)
        end
      end

      private

      def find_doctor(id)
        Doctor.find(id)
      end
    end
  end
end
