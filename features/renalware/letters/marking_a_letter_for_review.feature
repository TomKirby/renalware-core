Feature: Marking a letter for review

  A letter maybe authored by someone else other than the doctor such as a clinician or nurse.
  The letter than needs to be reviewed by the doctor before it can be sent to the
  recipients. A letter will be transitioned from "draft" to "typed" signalling the
  letter is ready for review by the doctor.

  Background:
    Given Nathalie is a nurse
    And Patty is a patient
    And Doug is Patty's doctor

  @web
  Scenario: A nurse marked the letter typed
    Given Patty has a recorded letter
    When Nathalie marks the letter typed
    Then Doug can review the letter
    And Doug can archive letter
