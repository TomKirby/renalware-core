require 'rails_helper'

RSpec.describe PdRegimesController, :type => :controller do

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it 'creates a new PD Regime' do
        expect { post :create, pd_regime: { start_date: '01/02/2015' } }.to change(PdRegime, :count).by(1)
        expect(response).to redirect_to(pd_info_patient_path(@patient))
      end
    end

    context "with invalid attributes" do
      it 'creates a new PD Regime' do
        expect { post :create, pd_regime: { start_date: nil } }.to change(PdRegime, :count).by(0)
        expect(response).to render_template(:new)
      end
    end
  end

end
