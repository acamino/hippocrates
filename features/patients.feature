Feature: User can manage the patients

  Scenario: Listing patients
    Given the following patients exist:
      | first_name | last_name |
      | Reed       | Richards  |
      | Sue        | Storm     |
    When I go to the patients page
    Then I see Reed and Sue

  Scenario: Creating a patient
    Given Reed is not a registered patient
    When I go to the new patient page
    And I input Reeds information
    Then I see a creation message

  Scenario: Updating a patient
    Given Reed is a registered patient
    When I go to the edit patient page
    And I update Reed's informaton
    Then I see an update message
