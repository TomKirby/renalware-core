Given(/^some patients who need renal treatment$/) do
  step "I have a patient in the database"
end

Given(/^I've waited for the indexes to update$/) do
  sleep 1
end

When(/^I search for a patient by hospital centre code$/) do
  fill_in "patient_search", :with => "888"
  click_on "Find Patient"
end

When(/^I search for a patient by forename$/) do
  fill_in "patient_search", :with => "Roger"
  click_on "Find Patient"
end

When(/^I search for a patient by the first few letters of the surname$/) do
  fill_in "patient_search", :with => "Rog"
  click_on "Find Patient"
end

When(/^I search for a patient by surname$/) do
  fill_in "patient_search", :with => "rabbit"
  click_on "Find Patient"
end

Then(/^they will see a list of matching results for patients$/) do
  expect(page.has_content?("RABBIT, Roger")).to be true
end