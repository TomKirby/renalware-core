# TODO: Remove this once we have this column populated in the DB seeds
observation_required_regex =
  /^request description ([\d\w]+) requires observation description ([\d\w]+)$/
Given(observation_required_regex) do |request_code, description_code|
  observation_description =
    Renalware::Pathology::ObservationDescription.find_by(code: description_code)
  request_description = Renalware::Pathology::RequestDescription.find_by(code: request_code)

  unless request_description.required_observation_description_id.present?
    request_description.update_attributes!(
      required_observation_description_id: observation_description.id
    )
  end
end

# TODO: Remove this once we have this column populated in the DB seeds
request_description_expiration_regex =
  /^the request description ([\d\w]+) has an expiration of (\d+) days$/
Given(request_description_expiration_regex) do |request_code, expiration_days|
  request_description = Renalware::Pathology::RequestDescription.find_by(code: request_code)
  request_description.update_attributes!(
    expiration_days: expiration_days
  )
end

Given(/^a ([\d\w]+) test was requested for Patty(\s|\s(\d+) days ago)$/) do |code, _time_ago, days|
  if days.present?
    requested_at = (Time.current - days.days).to_date

    create_request(
      patient: @patty,
      request_descriptions: [code],
      requested_at: requested_at
    )
  end
end

Given(/^a ([\d\w]+) test was observed for Patty(\s|\s(\d+) days ago)$/) do |code, _time_ago, days|
  if days.present?
    observed_at = (Time.current - days.days).to_date

    record_observations(patient: @patty, observations_attributes:
      [{ "code" => code, "observed_at" => observed_at.to_s, "result" => "100" }]
    )
  end
end

Given(/^the following observations were recorded$/) do |table|
  record_observations(patient: @patty, observations_attributes: table.hashes)
end

Then(/^an observation request is created with the following attributes:$/) do |table|
  expect_observation_request_to_be_created(table.rows_hash)
end

Then(/^an observations are created with the following attributes:$/) do |table|
  expect_observations_to_be_created(table.hashes)
end

Then(/^the doctor views the following archived pathology result report:$/) do |table|
  expect_pathology_result_report(user: @nathalie, patient: @patty, rows: table.raw)
end

Then(/^the doctor views the following recents observation results:$/) do |table|
  expect_pathology_recent_observations(user: @nathalie, patient: @patty, rows: table.raw)
end

Then(/^the doctor views the following historical observation results:$/) do |table|
  expect_pathology_historical_observations(user: @nathalie, patient: @patty, rows: table.raw)
end

Then(/^the doctor views the following current observation results:$/) do |table|
  expect_pathology_current_observations(user: @nathalie, patient: @patty, rows: table.raw)
end
