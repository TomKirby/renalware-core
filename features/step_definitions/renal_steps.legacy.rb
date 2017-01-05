Given(/^Clyde has Patty's renal profile$/) do
  visit edit_patient_renal_profile_path(@patty)
end

When(/^Clyde submits Patty's ESRF details$/) do
  fill_in "ESRF on", with: fake_date.to_s

  fill_autocomplete "form.simple_form", "prd_description_auto_complete",
    with: "Cystinuria", select: "Cystinuria"

  click_on "Save"
end

Then(/^Patty's renal profile is updated$/) do
  within ".renal-profile" do
    expect(page).to have_content(I18n.l(fake_date))
    expect(page).to have_content("Cystinuria")
  end
end
