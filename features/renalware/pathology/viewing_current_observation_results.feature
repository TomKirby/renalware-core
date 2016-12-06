Feature: Viewing current pathology observation results for a patient

  A doctor views the current pathology observation results for a patient to
  determine their health status.

  @web
  Scenario: Multiple observation results recorded
    Given Patty is a patient
    And Nathalie is a nurse
    And the following observations were recorded
      | code | result | observed_at         |
      | HGB  | 6.09   | 2009-Nov-11 12:00:00 |
      | MCV  | 4.00   | 2009-Nov-11 12:00:00 |
      | HGB  | 5.09   | 2009-Nov-12 12:00:00 |
      | MCV  | 3.00   | 2009-Nov-12 12:00:00 |
      | WBC  | 2.00   | 2009-Nov-13 12:00:00 |
    Then the doctor views the following current observation results:
      | description | result | date       |
      | HGB         | 5.09   | 12-Nov-2009 |
      | MCV         | 3.00   | 12-Nov-2009 |
      | AL          |        |            |
      | WBC         | 2.00   | 13-Nov-2009 |
