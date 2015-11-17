Feature: Recording the operation on a donor

  A patient requires the transplant of one or many organs: kidney, pancreas or liver.
  The donor donates the organ during an operation.

  Background:
    Given Clyde is a clinician
    And Don is a patient

  @web
  Scenario: A clinician recorded a transplant operation on a donor
    When Clyde records a donor operation for Don
    Then Don has a new donor operation

  @web
  Scenario: A clinician udpated a transplant operation on a donor
    Given Don has a donor operation
    Then Clyde can update Don's donor operation

  @web
  Scenario: A clinician submitted an erroneous transplant operation on a donor
    When Clyde submits an erroneous donor operation
    Then the donor operation is not accepted