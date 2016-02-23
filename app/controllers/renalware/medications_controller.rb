require_dependency "collection_presenter"

module Renalware
  class MedicationsController < BaseController
    include MedicationsHelper

    before_action :load_patient

    def index
      @treatable = treatable_class.find(treatable_id)

      render_index
    end

    def new
      @treatable = treatable_class.find(treatable_id)
      medication = Medication.new(treatable: @treatable)

      render_form(medication, url: patient_medications_path(@patient, @treatable))
    end

    def create
      @treatable = treatable_class.find(treatable_id)

      medication = @patient.medications.new(
        medication_params.merge(treatable: @treatable)
      )

      if medication.save
        render_index
      else
        render_form(medication, url: patient_medications_path(@patient, @treatable))
      end
    end

    def edit
      medication = @patient.medications.find(params[:id])
      @treatable = medication.treatable

      render_form(medication, url: patient_medication_path(@patient, medication))
    end

    def update
      medication = @patient.medications.find(params[:id])
      @treatable = medication.treatable

      if medication.update(medication_params)
        render_index
      else
        render_form(medication, url: patient_medication_path(@patient, medication))
      end
    end

    def destroy
      medication = @patient.medications.find(params[:id])
      @treatable = medication.treatable

      medication.destroy!

      render_index
    end

    private

    def render_index
      render "index", locals: {
        query: medications_query, patient: @patient,
        treatable: @treatable, medications: medications
      }
    end

    def render_form(medication, url:)
      render "form", locals: {
        patient: @patient, treatable: @treatable,
        medication: medication, url: url
      }
    end

    def treatable_class
      @treatable_class ||= treatable_type.singularize.classify.constantize
    end

    def medication_params
      params.require(:medication).permit(
        :drug_id, :dose, :medication_route_id, :frequency,
        :notes, :start_date, :end_date, :provider
      )
    end

    def treatable_type
      params.fetch(:treatable_type)
    end

    def treatable_id
      params.fetch(:treatable_id)
    end

    def medications_query
      @medications_query ||= @treatable.medications.search(params[:q]).tap do | query|
        query.sorts = [Medication.default_search_order] if query.sorts.empty?
      end
    end

    def medications
      CollectionPresenter.new(medications_query.result, Medications::MedicationPresenter)
    end
  end
end
