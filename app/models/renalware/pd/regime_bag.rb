require_dependency "renalware/pd"

module Renalware
  module PD
    class RegimeBag < ActiveRecord::Base

      before_save :assign_days_per_week

      belongs_to :bag_type
      belongs_to :regime

      validates :bag_type, presence: true
      validates :volume, presence: true

      validates :volume, numericality: {
        allow_nil: true, greater_than_or_equal_to: 100, less_than_or_equal_to: 10000
      }

      validate :must_select_one_day

      def initialize(attributes = nil, options = {})
        super
        days_to_sym.each do |day|
          self.public_send(:"#{day}=", true)
        end
        self.attributes = attributes unless attributes.nil?
      end

      def days
        days_to_sym.map do |day|
          self.public_send(day)
        end
      end

      def days_to_sym
        Date::DAYNAMES.map { |n| n.underscore.to_sym }
      end

      def weekly_total_glucose_ml_per_bag
        assign_days_per_week * self.volume
      end

      private

      def assign_days_per_week
        self.per_week = days.keep_if { |d| d == true }.size
      end

      def must_select_one_day
        return unless self.days.count(false) == 7

        errors.add(:days, "must be assigned at least one day of the week")
      end
    end
  end
end
