require_dependency "renalware/hd/base_controller"

module Renalware
  module PD
    class PeritonitisEpisodesController < BaseController
      include PresenterHelper

      def show
        prescriptions = current_episode.prescriptions.ordered
        render locals: {
          patient: patient,
          peritonitis_episode: present(current_episode, PeritonitisEpisodePresenter),
          prescriptions: present(prescriptions, Medications::PrescriptionPresenter),
          treatable: present(current_episode, Medications::TreatablePresenter)
        }
      end

      def new
        render locals: {
          peritonitis_episode: new_episode,
          patient: patient
        }
      end

      def create
        save_episode(new_episode)
      end

      def edit
        render locals: {
          peritonitis_episode: current_episode,
          patient: patient
        }
      end

      def update
        save_episode(current_episode)
      end

      def save_episode(episode)
        command = SavePeritonitisEpisode.new(patient: patient, episode: episode)
        command.subscribe(self)
        command.call(params: peritonitis_episode_params)
      end

      def save_success(episode)
        respond_to do |format|
          format.js do
            render locals: {
              peritonitis_episode: present(episode, PeritonitisEpisodePresenter),
              patient: patient
            }
          end
          format.html { redirect_after_successful_save(episode) }
        end
      end

      def save_failure(episode)
        flash[:error] = t(".failed", model_name: "peritonitis episode")
        action = action_name.to_sym == :create ? :new : :edit
        render action, locals: {
          peritonitis_episode: episode,
          patient: patient
        }
      end

      private

      def redirect_after_successful_save(episode)
        url = patient_pd_peritonitis_episode_path(patient, episode)
        message = t(".success", model_name: "peritonitis episode")
        redirect_to url, notice: message
      end

      def current_episode
        @current_episode ||= begin
          episode = PeritonitisEpisode.for_patient(patient).find(params[:id])
          authorize(episode) if episode.present?
          episode
        end
      end

      def new_episode
        episode = PeritonitisEpisode.for_patient(patient).new
        authorize(episode)
        episode
      end

      def peritonitis_episode_params
        params
          .require(:pd_peritonitis_episode)
          .permit(
            :diagnosis_date, :treatment_start_date, :treatment_end_date,
            :catheter_removed, :line_break, :exit_site_infection,
            :diarrhoea, :abdominal_pain, :fluid_description_id, :white_cell_total,
            :white_cell_neutro, :white_cell_lympho, :white_cell_degen,
            :white_cell_other, :notes, { episode_types: [] }
          )
      end
    end
  end
end
