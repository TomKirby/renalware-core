Feature: View a personal dashboard

  The personal dashboard presents pertinent information to the current system user:
  - draft letters the user is currently typing
  - letters pending review by the user
  - patients the user has bookmarked

  Background:
    Given Nathalie is a nurse
    And Patty is a patient

  Scenario: The system user was drafting a letter (i.e the typist)
    When Nathalie drafts a letter for Patty
    Then Patty's draft letter is accessible from Nathalie's dashboard

  @wip
  Scenario: The system user is an author of a letter pending review

  @wip
  Scenario: The system user bookmarked a patient
