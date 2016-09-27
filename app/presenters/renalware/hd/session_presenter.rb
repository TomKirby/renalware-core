module Renalware
  module HD
    class SessionPresenter < SimpleDelegator
      attr_reader :preference_set
      delegate :info,
               :observations_before,
               :observations_after,
               :dialysis,
               to: :document
      delegate :access_type,
               :access_type_abbreviation,
               :access_site,
               :access_side,
               :machine_no,
               to: :info
      delegate :arterial_pressure,
               :venous_pressure,
               :blood_flow,
               :fluid_removed,
               :litres_processed,
               :machine_urr,
               :machine_ktv,
               to: :dialysis
      delegate :unit_code,
               to: :hospital_unit,
               prefix: true

      def class
        __getobj__.class
      end

      def ongoing_css_class
        "active" unless signed_off?
      end

      def performed_on
        ::I18n.l(super)
      end

      def start_time
        ::I18n.l(super, format: :time)
      end

      def end_time
        ::I18n.l(super, format: :time)
      end

      def duration
        super && Renalware::Duration.from_minutes(super)
      end

      def before_measurement_for(measurement)
        observations_before.send(measurement.to_sym)
      end

      def after_measurement_for(measurement)
        observations_after.send(measurement.to_sym)
      end

      def change_in(measurement)
        pre = before_measurement_for(measurement)
        post = after_measurement_for(measurement)
        return if pre.blank? || post.blank?
        case pre
        when ::Float ; (post - pre).round(1)
        when ::Fixnum ;(post - pre)
        end
      end

      def summarised_access_used
        Renalware::HD::SessionAccessPresenter.new(self).to_html
      end

      def access_used
        Renalware::HD::SessionAccessPresenter.new(self).to_s
      end
    end
  end
end
