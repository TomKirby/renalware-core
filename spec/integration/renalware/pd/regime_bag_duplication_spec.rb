require "rails_helper"

module Renalware
  feature "PD Regime bag duplication", js: true do
    background do
      @patient = create(:patient)
      @bag_type = create(:bag_type, description: "Option 1")
      login_as_clinician
    end

    scenario "duplicate an existing bag" do
      visit patient_pd_dashboard_path(@patient)
      click_link "Add APD Regime"

      fill_in "Start date", with: "25/05/2015"

      select "APD Dry Day", from: "Treatment"

      click_link "Add Bag"

      expect(page.all(".fields").length).to eq(1)

      within(".fields:first-child") do
        select "2000", from: "Volume (ml)"
        select @bag_type.description, from: "* Bag type"
        uncheck "Tue"
        uncheck "Fri"

        click_link "Duplicate"
      end

      expect(page.all(".fields").length).to eq(2)

      within(".fields:last-child") do
        selects = page.all("select")
        expect(selects.first.value).to eq(@bag_type.id.to_s)
        expect(selects.last.value).to eq("2000")
        check "Tue"
        select "1500", from: "Volume (ml)"
      end

      click_button "Save"

      expect(page.current_path).to eq(patient_pd_dashboard_path(@patient))

      regimes = PD::Regime.all
      expect(regimes.length).to eq(1)
      bags = regimes.first.bags
      expect(bags.length).to eq(2)
      expect(bags[0].days).to eq([true, true, false, true, true, false, true]) # no tue fri
      expect(bags[0].volume).to eq(2000)
      expect(bags[1].days).to eq([true, true, true, true, true, false, true]) # no  fri
      expect(bags[1].volume).to eq(1500)
    end
  end
end