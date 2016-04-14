Feature: Determine tests based on global rules

  The global pathology algorithm checks if there are any rules which apply to the patient and lists the required tests accordingly.

  The rules table lists rules for each test which is based on a param_type and a frequency.

  The param_type references a ruby class which allows for some kind of comparison to be made, i.e. if the patient's medications includes a certain drug (param_type = MedicationIncludesDrugId) or if the patient's modality is a certain value (param_type = ModalityIs).

  The frequency also references a ruby class which states whether or not a test should be made based on the last time that test was taken i.e.

  | frequency | description                             |
  | Once      | if tested before then don't test        |
  | Always    | if tested before or not then test       |
  | Weekly    | if tested < 7 days ago then don't test  |
  | Monthly   | if tested < 28 days ago then don't test |

  Background:
    Given there exist the following global rules:
      | id                         | 1                   |
      | observation_description_id | 152                 |
      | regime                     | 'HD'                |
      | param_type                 | ObservationResultLT |
      | param_identifier           | 765                 |
      | param_comparison_value     | 100                 |
      | frequency                  | <frequency>         |

  Scenario Outline:

    Given Patty is a patient
    And Patty has an observation result value of <observation_result>
    And Patty was last tested for vitamin B12 Serum <last_tested>
    When the global pathology algorithm is ran for Patty in regime <regime>
    Then the required pathology should includes the test <test_required>

    Examples:
      | regime     | frequency | observation_result | last_tested | test_required |
      | Nephrology | Once      | 99                 |             | yes           |
      #| Nephrology | Once      | 100                |             | no            |
      | Nephrology | Once      | 99                 | 5 days ago  | no            |
      #| Nephrology | Once      | 100                | 5 days ago  | no            |

      #| Nephrology | Always    | 99                 | nil         | yes           |
      #| Nephrology | Always    | 100                | nil         | no            |
      #| Nephrology | Always    | 99                 | 5 days ago  | yes           |
      #| Nephrology | Always    | 100                | 5 days ago  | no            |

      #| Nephrology | Weekly    | 99                 | nil         | yes           |
      #| Nephrology | Weekly    | 100                | nil         | no            |
      #| Nephrology | Weekly    | 99                 | 5 days ago  | no            |
      #| Nephrology | Weekly    | 100                | 5 days ago  | no            |
      #| Nephrology | Weekly    | 99                 | 7 days ago  | yes           |
      #| Nephrology | Weekly    | 100                | 7 days ago  | no            |
