# frozen_string_literal: true

require "document/enum"

module Renalware
  class InfectionStatus < NestedAttribute
    attribute :value, Document::Enum,
      enums: %i(negative positive test_result_awaited not_tested unknown)
  end
end
