Feature: A Clinician records an infection for a patient caused by Peritoneal Dialysis(PD)

Background:
  Given that I'm logged in
    And there are ethnicities in the database
    And there are modalities in the database
    And there are modality reasons in the database
    And there are edta causes of death in the database 
    And there are organisms in the database
    And there are drugs in the database
    And there are drug types in the database
    And existing drugs have been assigned drug types
    And there are medication routes in the database
    And there are episode types in the database
    And there are fluid descriptions in the database
    And some patients who need renal treatment
# @wip
Scenario: Clinician records an episode of peritonitis
  Given a patient has PD
  When the Clinician records the episode of peritonitis
  Then the recorded episode should be displayed on PD info page
# @wip
Scenario: Clinician updates an episode of peritonitis
  Given a patient has PD
    And a patient has a recently recorded episode of peritonitis 
  When the Clinician updates the episode of peritonitis
    And they add a medication to this episode of peritonitis
  Then the updated episode should be displayed on PD info page
    And the new medication should be displayed on the updated peritonitis form.
@wip
Scenario: Clinician records an exit site infection
  Given a patient has PD
  When the Clinician records an exit site infection
  Then the recorded exit site infection should be displayed on PD info page 
@wip
Scenario: Clinician updates an exit site infection
  Given a patient has PD
    And a patient has a recently recorded exit site infection
  When the Clinician updates an exit site infection
  Then the updated exit site infection should be displayed on PD info page 






