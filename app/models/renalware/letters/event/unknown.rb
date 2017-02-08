require_dependency "renalware/letters/event"

module Renalware
  module Letters
    class Event::Unknown < Event
      def initialize(object = nil)
        super(object)
      end

      def description; end

      def to_s
        "Simple"
      end
    end
  end
end
