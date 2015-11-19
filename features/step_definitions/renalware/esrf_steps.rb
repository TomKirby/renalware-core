Given(/^there are prd in the database$/) do
  %w(Oligomeganephronia Cystinuria Xanthinuria).each do |term|
    instance_variable_set(:"@#{term.downcase}", FactoryGirl.create(:prd_description, term: term))
  end
end

Given(/^Clyde is on Patty's ESRF summary$/) do
  visit edit_patient_esrf_path(@patty)
end

When(/^Clyde completes Patty's ESRF from$/) do
  fill_in "Date", with: fake_date
  select "Cystinuria", from: "Primary Renal Diagnosis (PRD)"

  click_on "Save"
end

Then(/^Patty's ESRF details should be updated$/) do
  within ".renal-profile" do
    expect(page).to have_content(fake_date)
    expect(page).to have_content("Cystinuria")
  end
end