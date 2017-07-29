Feature: User can manage special patients

  Scenario: Listing patients
    Given the following special patients:
      | first_name | last_name |
      | Ada        | Lovelace  |
      | Charles    | Babbage   |
    When I open special patients page
    Then I see "Ada"
    And I see "Charles"
