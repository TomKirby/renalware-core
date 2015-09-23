require 'rails_helper'

module Renalware
  RSpec.describe PdRegimesController, :type => :controller do

    before do
      @patient = create(:patient)
      @bag_type = create(:bag_type)
      @capd_regime = create(:capd_regime,
                      pd_regime_bags_attributes: [
                        bag_type_id: @bag_type.id,
                        volume: 600,
                        sunday: true,
                        monday: true,
                        tuesday: true,
                        wednesday: true,
                        thursday: true,
                        friday: true,
                        saturday: true
                      ]
                    )
    end

    describe 'GET #new' do
      it 'renders the new template' do
        get :new, patient_id: @patient.id

        expect(response).to render_template('new')
      end
    end

    describe 'POST #create' do
      context "with valid attributes" do
        it 'creates a new CAPD Regime' do
          expect { post :create,
            patient_id: @patient.id,
            pd_regime: {
              type: 'Renalware::CapdRegime',
              start_date: '01/02/2015',
              treatment: 'CAPD 3 exchanges per day',
              pd_regime_bags_attributes: [
                bag_type_id: @bag_type.id,
                volume: 600,
                sunday: true,
                monday: true,
                tuesday: true,
                wednesday: true,
                thursday: true,
                friday: true,
                saturday: true
              ]
            }
          }.to change(PdRegime, :count).by(1)

          expect(response).to redirect_to(pd_info_patient_path(@patient))
        end
      end

      context "with invalid attributes" do
        it 'creates a new CAPD Regime' do
          expect {
            post :create,
            patient_id: @patient.id,
            pd_regime: { type: 'Renalware::CapdRegime',
              start_date: nil,
              treatment: nil
            }
          }.to change(PdRegime, :count).by(0)

          expect(response).to render_template(:new)
        end
      end

      context 'add bag' do
        it 'adds a bag to the unsaved CAPD Regime' do
          expect {
            post :create,
            patient_id: @patient.id,
            actions: { add_bag: 'Add Bag' },
            pd_regime: { type: 'Renalware::CapdRegime',
              start_date: Date.today,
              treatment: 'CAPD 3 exchanges per day' }
          }.to change(PdRegime, :count).by(0)

          expect(assigns(:pd_regime).pd_regime_bags.size).to eq(1)
        end
      end

      context 'remove bag' do
        it 'removes a bag from the unsaved CAPD Regime' do
          post :create,
          patient_id: @patient.id,
          actions: { remove: { '0' => 'Remove' } },
          pd_regime: { type: 'Renalware::CapdRegime',
            start_date: Date.today,
            treatment: 'CAPD 4 exchanges per day',
            pd_regime_bags_attributes: [{ bag_type_id:'100', volume:'2', per_week:'1', monday:true }]
          }

          expect(assigns(:pd_regime).pd_regime_bags.size).to eq(0)
        end
      end
    end

    describe 'PUT #update' do
      context "with valid attributes" do
        it 'updates a CAPD Regime' do
          put :update,
          id: @capd_regime.id,
          patient_id: @patient.id,
          pd_regime: { type: 'Renalware::CapdRegime',
            start_date: '15/02/2015',
            treatment: ' CAPD 5 exchanges per day'
          }

          expect(response).to redirect_to(pd_info_patient_path(@patient))
        end
      end

      context "with invalid attributes" do
        it 'update a CAPD Regime' do
          put :update,
          id: @capd_regime.id,
          patient_id: @patient.id,
          pd_regime: { type: 'Renalware::CapdRegime',
            start_date: nil,
            treatment: nil
          }

          expect(response).to render_template(:edit)
        end
      end

      context 'add bag' do
        it 'adds a bag to the saved CAPD Regime' do
          expect {
            put :update,
            id: @capd_regime.id,
            patient_id: @patient.id,
            actions: { add_bag: 'Add Bag' },
            pd_regime: { type: 'Renalware::CapdRegime',
              start_date: Date.today,
              treatment: 'CAPD 3 exchanges per day'
            }
          }.to change(PdRegime, :count).by(0)

          expect(assigns(:pd_regime).pd_regime_bags.size).to eq(2)
        end
      end

      context 'remove bag' do
        it 'removes a bag from the unsaved CAPD Regime' do
          @capd_regime.pd_regime_bags << create(:pd_regime_bag)
          put :update,
          id: @capd_regime.id,
          patient_id: @patient.id,
          actions: { remove: { '0' => 'Remove' } },
          pd_regime: { type: 'Renalware::CapdRegime',
            start_date: Date.today,
            treatment: 'CAPD 3 exchanges per day'
          }

          expect(assigns(:pd_regime).pd_regime_bags.size).to eq(1)
        end
      end
    end
  end
end