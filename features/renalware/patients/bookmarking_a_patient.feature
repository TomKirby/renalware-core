Feature: Bookmarking a patient

  A logged in user bookmarks a patient and sees that patient in their dashboard. This can be used to
  remind the user of certain patients that need special attention.

  @web @javascript
  Scenario: A user bookmarks a patient
    Given Clyde is a clinician
    And the following patients:
      | Patty    |
      | Don      |
      | Yossef   |
    When Clyde bookmarks Patty
    And Clyde bookmarks Yossef
    Then the following patients appear in Clyde's bookmarked patient list:
      | Patty    |
      | Yossef   |
