Feature: Listing the letters

  System users view all letters in the system. A user applies filters to the
  different facets, such as the current state of the letter and who authored
  it. This feature allows a secretary to filter approved letters for their
  designated doctor (the author) to print.

  TODO: filtering

  Background:
    Given Clyde is a clinician
    And these letters are recorded
      | patient         | letter_status      |
      | Roger Rabbit    | draft              |
      | Jessica Rabbit  | pending_review     |
      | Bugs Bunny      | approved           |
      | Daffy Duck      | completed          |

  @web
  Scenario: A clinician reported the list of letters
    When Clyde views the list of letters
    Then Clyde sees these letters
      | patient         | letter_status      |
      | Roger Rabbit    | draft              |
      | Jessica Rabbit  | pendingreview     |
      | Bugs Bunny      | approved           |
      | Daffy Duck      | completed          |
