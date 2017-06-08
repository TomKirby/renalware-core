require_dependency "collection_presenter"

module Renalware
  module HD
    class DashboardPresenter
      attr_accessor :patient

      def initialize(patient, view_context)
        @patient = patient
        @view_context = view_context
      end

      def preference_set
        @preference_set ||= PreferenceSet.for_patient(patient).first_or_initialize
      end

      def profile
        @profile ||= begin
          ProfilePresenter.new(Profile.for_patient(patient).first_or_initialize)
        end
      end

      def access
        @access ||= begin
          access_profile = Renalware::Accesses.cast_patient(patient).current_profile
          Accesses::ProfilePresenter.new(access_profile)
        end
      end

      def sessions
        @sessions ||= begin
          hd_sessions = Session.includes(:hospital_unit, :patient)
                               .for_patient(patient)
                               .limit(10).ordered
          CollectionPresenter.new(hd_sessions, SessionPresenter, view_context)
        end
      end

      private

      attr_accessor :view_context
    end
  end
end
