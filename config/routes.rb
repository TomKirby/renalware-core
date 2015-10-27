Rails.application.routes.draw do

  devise_for :users, class_name: "Renalware::User", controllers: {
    registrations: "renalware/devise/registrations",
    sessions: "renalware/devise/sessions"
  }

  scope module: "renalware" do
    # TODO - This will probably change in future
    root to: "patients#index"

    namespace :admin do
      resources :users
    end


    get "authors/:author_id/letters", to: "letters#author", as: "author_letters"

    resources :bag_types, except: [:show]

    resources :clinic_visits do
      resources :letters, controller: "clinic_letters", only: [:new, :edit]
    end

    resources :deaths, only: :index, as: :patient_deaths
    resources :doctors

    resources :drugs, except: [:show] do
      collection do
        get :selected_drugs
      end
    end

    resources :event_types, except: [:show]
    resources :modality_codes, except: [:show]
    resources :modality_reasons, only: [:index]

    resources :patients, except: [:destroy] do
      member do
        get :capd_regime
        get :apd_regime
      end

      resource :clinical_summary, only: :show
      resource :death, only: [:edit, :update]
      resource :esrf, only: [:edit, :update], controller: "esrf"
      resource :pd_summary, only: :show

      resources :apd_regimes, controller: "pd_regimes", type: "ApdRegime"
      resources :capd_regimes, controller: "pd_regimes", type: "CapdRegime"
      resources :clinic_visits
      resources :events, only: [:new, :create, :index]
      resources :exit_site_infections, only: [:new, :create, :show, :edit, :update]
      resources :letters

      resources :medications, only: :index
      patch "medications", to: "medications#update", as: "medications_batch"

      resources :modalities, only: [:new, :create, :index]
      resources :pd_regimes, only: [:new, :create, :edit, :update, :show]
      resources :peritonitis_episodes, only: [:new, :create, :show, :edit, :update]

      resources :problems, only: :index
      patch "problems", to: "problems#update", as: "problems_batch"

      namespace :transplants do
        resource :recipient_workup, except: :destroy
        resource :donor_workup, except: :destroy
      end
    end

    resources :snomed, only: [:index]
  end
end
