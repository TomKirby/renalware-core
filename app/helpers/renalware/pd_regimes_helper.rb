module Renalware
  module PDRegimesHelper

    def therapy_times
      PD::APDRegime::VALID_THERAPY_TIMES.map do |minutes|
        [Duration.from_minutes(minutes).to_s, minutes]
      end
    end

    def default_daily_glucose_average(glucose)
      if glucose.blank?
        0
      else
        glucose
      end
    end

    def capd_apd_scope(regime)
      if regime == "Renalware::PD::CAPDRegime"
        ["CAPD 3 exchanges per day", "CAPD 4 exchanges per day", "CAPD 5 exchanges per day"]
      else
        ["APD Dry Day", "APD Wet Day", "APD Wet day with additional exchange"]
      end
    end

    def capd_apd_title(regime)
      if regime == "Renalware::PD::CAPDRegime"
        "CAPD"
      else
        "APD"
      end
    end

    def pd_regime_bags(regime_bags)
      if regime_bags.blank?
        "Unknown"
      else
        formatted_pd_regime_bags(regime_bags)
      end
    end

    def formatted_pd_regime_bags(regime_bags)
      safe_join(regime_bags.map { |rb| formatted_pd_regime_bag(rb) })
    end

    def formatted_pd_regime_bag(regime_bag)
      content_tag(:li, ["Bag type: #{regime_bag.bag_type.description}",
                "Volume: #{regime_bag.volume}ml",
                "No. per week: #{regime_bag.per_week}",
                "Days: #{pd_regime_bag_days(regime_bag)}"].join(", "))
    end

    def pd_regime_bag_days(regime_bag)
      days = []
      Date::DAYNAMES.each_with_index do |day, index|
        days << Date::ABBR_DAYNAMES[index] if regime_bag.public_send(day.downcase.to_sym)
      end
      days.join(", ")
    end
  end
end
