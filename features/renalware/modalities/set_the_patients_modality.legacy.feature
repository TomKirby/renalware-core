@legacy @web
Feature: Set the patient's modality

  Background:
    Given that I'm logged in
      And some patients who need renal treatment

  @javascript
  Scenario: Doctor adds a modality for a patient
    Given I choose to add a modality
    When I complete the modality form
    Then I should see a patient's modality on their clinical summary

  Scenario: Doctor adds a death modality for a patient
    Given I choose to add a modality
    When I select death modality
    When I complete the cause of death form
    Then I should see the date of death and causes of death in the patient's clinical profile
      And I should see the patient on the death list
      And I should see the patient's current modality set as death with start date
