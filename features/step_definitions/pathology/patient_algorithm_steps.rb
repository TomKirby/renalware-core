Given(/^(\w+) has a patient rule:$/) do |patient_name, table|
  patient = get_patient(patient_name)
  @patient_rule = create_patient_rule(
    table.rows_hash.merge(patient: patient)
  )
end

Given(/^the current date is between the rule's start\/end dates (yes|no)$/) do |within_rage|
  update_patient_rule_start_end_dates(@patient_rule, within_rage)
end

When(/^Clyde records a new patient rule for Patty$/) do
  @patient_rule_attributes = {
    patient: @patty,
    lab: "Biochemistry",
    test_description: "Test for HepBsAb",
    sample_number_bottles: 1,
    frequency_type: "Always",
    start_date: Date.current,
    end_date: Date.current + 1.week,
  }

  record_patient_rule(
    @clyde,
    @patient_rule_attributes
  )
end

When(/^the patient pathology algorithm is run for Patty$/) do
  @required_patient_observations = run_patient_algorithm(@patty, @clyde)
end

Then(/^it is determined the patient's observation is (required|not required)$/) do |determined|
  if determined == "required"
    expect(@required_patient_observations).to eq([@patient_rule])
  else
    expect(@required_patient_observations).to eq([])
  end
end

Then(/^Patty has a new patient rule$/) do
  expect_patient_rules_on_patient(@patty, @patient_rule_attributes)
end
