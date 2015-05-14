require 'rails_helper'

RSpec.describe ExitSiteInfection, :type => :model do

  it { should belong_to(:patient) }

  it { should have_many(:medications) }
  it { should have_many(:medication_routes).through(:medications) }
  it { should have_many(:patients).through(:medications) }
  it { should have_many(:infection_organisms) }
  it { should have_many(:organism_codes).through(:infection_organisms) }

  it { should accept_nested_attributes_for(:medications) }
  it { should accept_nested_attributes_for(:infection_organisms) }

  describe "exit site infection" do
    before do
      @patient = create(:patient)
      @es = FactoryGirl.build(:exit_site_infection)
      @lymphocytes = FactoryGirl.create(:organism_code, name: "Lymphocytes")
      @proteus = FactoryGirl.create(:organism_code, name: "Proteus")
      load_drugs
      load_drug_types
      set_drug_drug_types
      load_med_routes
    end

    context "medications" do
      it "can be assigned many medications and organisms/sensitivities" do

        @medication_one = FactoryGirl.create(:medication,
          patient: @patient,
          medicatable: @cephradine,
          medicatable_type: "Drug",
          treatable: @es,
          treatable_type: "ExitSiteInfection",
          dose: "20mg",
          medication_route: @im,
          frequency: "daily",
          notes: "with food",
          date: "02/03/2015",
          provider: 1,
          deleted_at: "NULL",
          created_at: "2015-02-03 18:21:04",
          updated_at: "2015-02-05 18:21:04"
        )

        @medication_two = FactoryGirl.create(:medication,
          patient: @patient,
          medicatable: @dicloxacillin,
          medicatable_type: "Drug",
          treatable: @es,
          treatable_type: "ExitSiteInfection",
          dose: "20mg",
          medication_route: @sc,
          frequency: "daily",
          notes: "with food",
          date: "02/03/2015",
          provider: 1,
          deleted_at: "NULL",
          created_at: "2015-02-03 18:21:04",
          updated_at: "2015-02-05 18:21:04"
        )

        @lymphocytes_sensitivity = @es.infection_organisms.build(organism_code: @lymphocytes, sensitivity: "Sensitive to Lymphocytes.")
        @proteus_sensitivity = @es.infection_organisms.build(organism_code: @proteus, sensitivity: "Sensitive to Proteus.")

        @es.medications << @medication_one
        @es.medications << @medication_two

        @es.save!
        @es.reload

        expect(@es.medications.size).to eq(2)
        expect(@es.infection_organisms.size).to eq(2)

        expect(@es.medications).to match_array([@medication_two, @medication_one])
        expect(@es.infection_organisms).to match_array([@proteus_sensitivity, @lymphocytes_sensitivity])

        expect(@es).to be_valid
      end
    end

  end
end
