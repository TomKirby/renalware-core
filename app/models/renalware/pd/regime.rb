require_dependency "renalware/pd"

module Renalware
  module PD
    class Regime < ActiveRecord::Base

      before_save :set_glucose_ml_percent_1_36
      before_save :set_glucose_ml_percent_2_27
      before_save :set_glucose_ml_percent_3_86

      belongs_to :patient, class_name: "Renalware::Patient"

      has_many :regime_bags
      has_many :bag_types, through: :regime_bags

      accepts_nested_attributes_for :regime_bags, allow_destroy: true

      scope :current, -> { order("created_at DESC").limit(1) }

      validates :patient, presence: true
      validates :start_date, presence: true
      validates :treatment, presence: true

      validate :min_one_regime_bag

      with_options if: :type_apd? do |apd|
        apd.validates :last_fill_ml, allow_nil: true, numericality:
          { greater_than_or_equal_to: 500, less_than_or_equal_to: 5000 }
        apd.validates :tidal_percentage, allow_nil: true, numericality:
          { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
        apd.validates :no_cycles_per_apd, allow_nil: true, numericality:
          { greater_than_or_equal_to: 2, less_than_or_equal_to: 20 }
        apd.validates :overnight_pd_ml, allow_nil: true, numericality:
          { greater_than_or_equal_to: 3000, less_than_or_equal_to: 25000 }
      end

      def type_apd?
        if self.type.present?
          self.type == "Renalware::APDRegime"
        end
      end

      private

      def min_one_regime_bag
        errors.add(:regime, "must be assigned at least one bag") if regime_bags.empty?
      end

      def match_bag_type
        glucose_types = [[], [], []]

        self.regime_bags.each do |bag|
          case bag.bag_type.glucose_grams_per_litre.to_f

          when 13.6
            glucose_types[0] << bag.weekly_total_glucose_ml_per_bag
          when 22.7
            glucose_types[1] << bag.weekly_total_glucose_ml_per_bag
          when 38.6
            glucose_types[2] << bag.weekly_total_glucose_ml_per_bag
          else
            glucose_types
          end
        end
        glucose_types
      end

      def set_glucose_ml_percent_1_36
        if match_bag_type[0].empty?
          0
        else
          per_week_total = match_bag_type[0].inject{ |sum, v| sum + v }
          glucose_daily_average = per_week_total/7.to_f
          self.glucose_ml_percent_1_36 = glucose_daily_average.round
        end
      end

      def set_glucose_ml_percent_2_27
        if match_bag_type[1].empty?
          0
        else
          per_week_total = match_bag_type[1].inject{ |sum, v| sum + v }
          glucose_daily_average = per_week_total/7.to_f
          self.glucose_ml_percent_2_27 = glucose_daily_average.round
        end
      end

      def set_glucose_ml_percent_3_86
        if match_bag_type[2].empty?
          0
        else
          per_week_total = match_bag_type[2].inject{ |sum, v| sum + v }
          glucose_daily_average = per_week_total/7.to_f
          self.glucose_ml_percent_3_86 = glucose_daily_average.round
        end
      end

    end
  end
end
