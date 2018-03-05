# frozen_string_literal: true

require_dependency "renalware"

module Renalware
  class Renalware::TimeOfDayPresenter < SimpleDelegator
    def to_s
      ::I18n.l self, format: :time
    end
  end
end
