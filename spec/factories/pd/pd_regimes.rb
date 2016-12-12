FactoryGirl.define do
  factory :pd_regime, class: "Renalware::PD::Regime" do
    patient
  end

  factory :capd_regime, class: "Renalware::PD::CAPDRegime" do
    patient
    start_date "01/02/2015"
    end_date "01/02/2020"
    treatment "CAPD 3 exchanges per day"
    amino_acid_volume 40
    icodextrin_volume 50
    add_hd false
  end

  factory :apd_regime, class: "Renalware::PD::APDRegime" do
    patient
    start_date "01/03/2015"
    end_date "02/04/2020"
    treatment "APD Wet day with additional exchange"
    amino_acid_volume 43
    icodextrin_volume 53
    add_hd false
    last_fill_volume 630
    # tidal_indicator true
    # tidal_percentage 70
    tidal_indicator false
    tidal_percentage nil
    tidal_full_drain_every_three_cycles nil
    no_cycles_per_apd 7
    overnight_volume 5100
    apd_machine_pac "123-4567-890"
  end

end
