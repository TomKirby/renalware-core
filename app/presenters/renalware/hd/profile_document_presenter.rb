module Renalware
  module HD
    class ProfileDocumentPresenter < ::DumbDelegator

      def care_level
        @care_level ||= CareLevelPresenter.new(super)
      end

      class CareLevelPresenter < ::DumbDelegator
        def to_s
          care_level = __getobj__
          return "" unless care_level.level.present?
          "#{care_level.level.try(:text)} (#{::I18n.l(care_level.assessed_on)})"
        end
      end
    end
  end
end