Feature: User can manage patients

  Scenario: Listing patients
    Given the following patients:
      | first_name | last_name |
      | Ada        | Lovelace  |
      | Charles    | Babbage   |
    When I open patients page
    Then I see "Ada"
    And I see "Charles"

  Scenario: Creating a patient
    Given Charles is not a patient
    When I open create patient page
    And I input Charles information
    Then I see a success message for creation

  Scenario: Updating a patient
    Given Ada is a patient
    When I open edit patient page
    And I update Ada's informaton
    Then I see a success message for update

  Scenario: Searching a patient
    Given the following patients:
      | first_name | last_name |
      | Ada        | Lovelace  |
      | Charles    | Babbage   |
    When I open patients page
    And I search for Ada
    Then I see "Ada"
    But I don't see "Charles"
