module World
  module Transplants
    def transplant_patient(patient)
      Renalware::Transplants.cast_patient(patient)
    end
  end
end

Dir[Rails.root.join("features/support/worlds/transplants/*.rb")].each { |f| require f }
