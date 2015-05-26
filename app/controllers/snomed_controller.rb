class SnomedController < ApplicationController

  # Cancancan authorization filter
  load_and_authorize_resource

  def index
    render :json => Snomed.search(snomed_params).to_h
  end

  private

  def snomed_params
    {
      'query' => params[:snomed_term],
      'semanticFilter' => params[:semantic_tag],
      'groupByConcept' => params.fetch(:group_by_concept, true)
    }
  end
end
