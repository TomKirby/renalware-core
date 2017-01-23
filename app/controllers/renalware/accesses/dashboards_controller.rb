require "collection_presenter"

module Renalware
  module Accesses
    class DashboardsController < Accesses::BaseController
      before_action :load_patient

      def show
        procedures = @patient.procedures.ordered
        profiles = @patient.profiles.past_and_future.ordered
        assessments = @patient.assessments.ordered

        @profiles = CollectionPresenter.new(profiles, ProfilePresenter)
        @procedures = CollectionPresenter.new(procedures, ProcedurePresenter)
        @assessments = CollectionPresenter.new(assessments, AssessmentPresenter)
        @current_profile = ProfilePresenter.new(@patient.current_profile)
      end
    end
  end
end
