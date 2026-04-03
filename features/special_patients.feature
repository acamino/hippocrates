Feature: User can manage special patients

  Scenario: Listing patients
    Given the following special patients:
      | first_name | last_name |
      | Ada        | Lovelace  |
      | Charles    | Babbage   |
    When I open special patients page
    Then I see "Ada"
    And I see "Charles"

  Scenario: Removing a special patient
    Given Ada is a special patient
    When I open special patients page
    And I remove Ada from special patients
    Then I see "removido correctamente"
    But I don't see "Ada"
