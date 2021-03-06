# frozen_string_literal: true

require "renalware/letters/part"

module Renalware
  module Letters
    class Part::Problems < DumbDelegator
      def initialize(patient, _letter, _event = Event::Unknown.new)
        @patient = patient
        super(patient.problems.includes(:notes))
      end

      def to_partial_path
        "renalware/letters/parts/problems"
      end
    end
  end
end
