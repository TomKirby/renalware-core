class ExitSiteInfectionsController < ApplicationController

  before_action :load_patient, :only => [:new, :create]

  def new
    @exit_site_infection = ExitSiteInfection.new
  end

  def create
    @exit_site_infection = ExitSiteInfection.new(allowed_params)
    @exit_site_infection.patient_id = @patient.id
    if @exit_site_infection.save
      redirect_to pd_info_patient_path(@patient), :notice => "You have successfully added a peritonitis episode."
    else
      render :new
    end
  end

  def edit
    @patient = Patient.find(params[:id])
    @exit_site_infection = ExitSiteInfection.find(params[:id])
  end

  def update
    @patient = Patient.find(params[:id])
    @exit_site_infection = ExitSiteInfection.find(params[:id])
    if @exit_site_infection.update(allowed_params)
      redirect_to pd_info_patient_path(@patient),
      :notice => "You have successfully updated an exit site infection."
    else
      render :edit 
    end
  end

  private
  def allowed_params
    params.require(:exit_site_infection).permit(:patient_id, :user_id, :diagnosis_date, :organism_1, 
    :organism_2, :treatment, :outcome, :notes, :antibiotic_1, :antibiotic_2, :antibiotic_3, 
    :antibiotic_1_route, :antibiotic_2_route, :antibiotic_3_route, :sensitivities)
  end

  def load_patient
    @patient = Patient.find(params[:patient_id])
  end 

end