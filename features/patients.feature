Feature: User can manage the patients

  Scenario: Listing patients
    Given the following patients exist:
      | first_name | last_name |
      | Bob        | Smith     |
      | Alice      | Doe       |
    When I go to the patients page
    Then I see Bob and Alice

  Scenario: Creating a patient
    Given Bob is not a registered patient
    When I go to the new patient page
    And I input Bob information
    Then I see a creation message

  Scenario: Updating a patient
    Given Bob is a registered patient
    When I go to the edit patient page
    And I update Bob's informaton
    Then I see a confirmation message for update

  Scenario: Searching a patient
    Given the following patients exist:
      | first_name | last_name |
      | Bob        | Smith     |
      | Alice      | Doe       |
    When I go to the patients page
    And I search for Doe
    Then I see Alice
    And I don't see Bob
