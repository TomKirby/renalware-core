Given(/^Clyde recorded a problem for Patty$/) do
  record_problem_for(patient: @patty, user: @clyde)
end

Given(/^Patty has recorded problems with notes$/) do
  seed_problem_for(@patty, Renalware::User.first)
end

Given(/^Patty has problems:$/) do |table|
  table.hashes.each do |row|
    create_problem(@patty,
      description: row[:description],
      date: parse_date_string(row[:recorded_on]),
      deleted_at: parse_date_string(row[:terminated_on])
    )
  end
end

When(/^Clyde records a problem for Patty$/) do
  record_problem_for(patient: @patty, user: @clyde)
end

When(/^records a note for the problem$/) do
  problem = problem_for(@patty)
  record_problem_note_for(problem: problem, user: @clyde)
end

When(/^Clyde views the list of problems for Patty$/) do
  @current_problems, @archived_problems = view_problems_list(@patty, @clyde)
end

Then(/^a problem is recorded for Patty$/) do
  expect_problem_to_be_recorded(patient: @patty)
  problem = problem_for(@patty)
  expect_problem_note_to_be_recorded(problem: problem)
end

Then(/^Clyde can revise the problem$/) do
  revise_problem_for(
    patient: @patty,
    user: @clyde,
    description: "something else"
  )

  expect_problem_revisions_to_be_recorded(patient: @patty)
end

Then(/^Clyde can add a note to the problem$/) do
  problem = problem_for(@patty)
  record_problem_note_for(problem: problem, user: @clyde)
  expect_problem_note_to_be_recorded(problem: problem)
end

Then(/^Clyde should see these current problems:$/) do |table|
  expect_problems_to_match_table(@current_problems, table)
end

Then(/^Clyde should see these archived problems:$/) do |table|
  expect_problems_to_match_table(@archived_problems, table)
end
