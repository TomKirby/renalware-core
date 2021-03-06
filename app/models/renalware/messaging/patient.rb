# frozen_string_literal: true

require_dependency "renalware/messaging"

module Renalware
  module Messaging
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :messages

      def to_s(format = :long)
        super(format)
      end
    end
  end
end
