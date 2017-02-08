require "rails_helper"

module Renalware
  RSpec.describe PDRegimesHelper, type: :helper do

    describe "default_daily_glucose_average" do
      before do
        @patient = create(:patient)

        @bag_type_13_6 = create(:bag_type,
                      manufacturer: "Baxter",
                      description: "Dianeal PD2 1.36% (Yellow)",
                      glucose_content: 1.36)

        @bag_type_22_7 = create(:bag_type,
                      manufacturer: "Baxter",
                      description: "Dianeal PD2 2.27% (Green)",
                      glucose_content: 2.27)

        @bag_type_38_6 = create(:bag_type,
                      manufacturer: "Baxter",
                      description: "Dianeal PD2 3.86% (Red)",
                      glucose_content: 3.86)

        @capd_regime = build(:capd_regime)

        @pd_regime_bag_13_6_1 = build(:pd_regime_bag,
                                bag_type: @bag_type_13_6,
                                volume: 1500,
                                sunday: false,
                                monday: true,
                                tuesday: false,
                                wednesday: true,
                                thursday: true,
                                friday: false,
                                saturday: false)

        @pd_regime_bag_13_6_2 = build(:pd_regime_bag,
                                bag_type: @bag_type_13_6,
                                volume: 1500,
                                sunday: false,
                                monday: true,
                                tuesday: false,
                                wednesday: true,
                                thursday: false,
                                friday: false,
                                saturday: false)

        @pd_regime_bag_22_7 = build(:pd_regime_bag,
                                bag_type: @bag_type_22_7,
                                volume: 2500,
                                sunday: false,
                                monday: true,
                                tuesday: true,
                                wednesday: false,
                                thursday: true,
                                friday: true,
                                saturday: true)

        @capd_regime.bags << @pd_regime_bag_13_6_1
        @capd_regime.bags << @pd_regime_bag_13_6_2
        @capd_regime.bags << @pd_regime_bag_22_7

        @capd_regime.save
      end

      context "has a glucose volume" do
        it "should return a glucose volume" do
          expect(default_daily_glucose_average(@capd_regime.glucose_volume_percent_1_36))
            .to eq(1071)
          expect(default_daily_glucose_average(@capd_regime.glucose_volume_percent_2_27))
            .to eq(1786)
        end
      end

      context "has no glucose volume" do
        it 'should display "0"' do
          expect(default_daily_glucose_average(@capd_regime.glucose_volume_percent_3_86)).to eq(0)
        end
      end
    end
  end
end
