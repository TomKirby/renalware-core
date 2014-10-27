Rails.application.routes.draw do
  resources :patients, :except => [:show, :destroy] do
    member do
      get :demographics
      get :clinical_summary
    end
  end

  resources :encounter_events, :only => [:new, :create, :index]

  # TODO - This will probably change in future
  root to: "patients#index"
end
