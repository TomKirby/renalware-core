Given(/^there are drugs in the database$/) do
  @drugs = ["Red", "Blue", "Yellow", "Green", "Amoxicillin", "Cephradine", "Dicloxacillin", "Metronidazole", "Penicillin", "Rifampin", "Tobramycin", "Vancomycin"]
  @drugs.map! { |d| @drug = Drug.create!(:name => d )}

  @red = @drugs[0]
  @blue = @drugs[1]
  @yellow = @drugs[2]
  @green = @drugs[3]
  @amoxicillin = @drugs[4]
  @cephradine = @drugs[5]
  @dicloxacillin = @drugs[6]
  @metronidazole = @drugs[7]
  @penicillin = @drugs[8]
  @rifampin = @drugs[9]
  @tobramycin = @drugs[10]
  @vancomycin = @drugs[11]
end

Given(/^there are drug types in the database$/) do
  @drug_types = ["Antibiotic", "ESA", "Immunosuppressant", "Peritonitis"]
  @drug_types.map! { |dt| DrugType.create!(:name => dt)}

  @antibiotic = @drug_types[0]
  @esa = @drug_types[1]
  @immunosuppressant = @drug_types[2]
  @peritonitis = @drug_types[3]
end

Given(/^existing drugs have been assigned drug types$/) do 
  @drug_drug_type_1 = DrugDrugType.create!(drug_id: @red.id, drug_type_id: @immunosuppressant.id)
  @drug_drug_type_2 = DrugDrugType.create!(drug_id: @blue.id, drug_type_id: @esa.id)
  @drug_drug_type_3 = DrugDrugType.create!(drug_id: @yellow.id, drug_type_id: @immunosuppressant.id)
  @drug_drug_type_5 = DrugDrugType.create!(drug_id: @green.id, drug_type_id: @esa.id)  
  @drug_drug_type_6 = DrugDrugType.create!(drug_id: @amoxicillin.id, drug_type_id: @antibiotic.id)  
  @drug_drug_type_7 = DrugDrugType.create!(drug_id: @amoxicillin.id, drug_type_id: @peritonitis.id)  
  @drug_drug_type_8 = DrugDrugType.create!(drug_id: @cephradine.id, drug_type_id: @antibiotic.id)  
  @drug_drug_type_9 = DrugDrugType.create!(drug_id: @cephradine.id, drug_type_id: @peritonitis.id)  
  @drug_drug_type_10 = DrugDrugType.create!(drug_id: @dicloxacillin.id, drug_type_id: @antibiotic.id)  
  @drug_drug_type_11 = DrugDrugType.create!(drug_id: @dicloxacillin.id, drug_type_id: @peritonitis.id)  
  @drug_drug_type_12 = DrugDrugType.create!(drug_id: @metronidazole.id, drug_type_id: @antibiotic.id)  
  @drug_drug_type_13 = DrugDrugType.create!(drug_id: @metronidazole.id, drug_type_id: @peritonitis.id)  
  @drug_drug_type_14 = DrugDrugType.create!(drug_id: @penicillin.id, drug_type_id: @antibiotic.id)  
  @drug_drug_type_15 = DrugDrugType.create!(drug_id: @penicillin.id, drug_type_id: @peritonitis.id)  
  @drug_drug_type_16 = DrugDrugType.create!(drug_id: @rifampin.id, drug_type_id: @antibiotic.id)  
  @drug_drug_type_17 = DrugDrugType.create!(drug_id: @rifampin.id, drug_type_id: @peritonitis.id)  
  @drug_drug_type_18 = DrugDrugType.create!(drug_id: @tobramycin.id, drug_type_id: @antibiotic.id)  
  @drug_drug_type_19 = DrugDrugType.create!(drug_id: @tobramycin.id, drug_type_id: @peritonitis.id)  
  @drug_drug_type_20 = DrugDrugType.create!(drug_id: @vancomycin.id, drug_type_id: @antibiotic.id)  
  @drug_drug_type_21 = DrugDrugType.create!(drug_id: @vancomycin.id, drug_type_id: @peritonitis.id)  
end

Given(/^that I'm on the add a new drug page$/) do
  visit new_drug_path
end

Given(/^that I choose to edit a drug$/) do
  visit edit_drug_path(@drug)
end

Given(/^I am on the drugs index$/) do
  visit drugs_path
end

When(/^I complete the form for a new drug$/) do
  fill_in "Drug Name", with: "I am a new drug"
  check "Antibiotic"
  check "Immunosuppressant"
  click_on "Save New Drug"
end

When(/^I complete the form for editing a drug$/) do
  fill_in "Drug Name", with: "I am an edited drug"
  uncheck('Peritonitis')
  click_on "Update Drug"
end

When(/^I choose to soft delete a drug$/) do
  find("##{@drug.id}-drug").click
end

Then(/^I should see the new drug on the drugs list$/) do
  expect(page.has_content? "I am a new drug").to be true
end

Then(/^I should see the new drug's categories\/types$/) do
  visit drug_drug_drug_types_path(Drug.all.fourth)
  expect(page.has_content? "Antibiotic").to be true 
  expect(page.has_content? "Immunosuppressant").to be true 
end

Then(/^I should see the updated drug on the drugs list$/) do
  expect(page.has_content? "I am an edited drug").to be true
  
  visit drug_drug_drug_types_path(@drug)
  page.assert_selector('li', :text => 'Antibiotic', :count => 1)
  page.assert_selector('li', :text => 'Peritonitis', :count => 0)
end

Then(/^I should see the drug removed from the drugs list$/) do
  expect(page.has_content? "Vancomycin").to be false
end


