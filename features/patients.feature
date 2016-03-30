Feature: User can see a list of patients

  Scenario: Listing patients
    Given the following patients exist:
      | first_name | last_name |
      | Reed       | Richards  |
      | Sue        | Storm     |
    When I go to the patients page
    Then I see Reed and Sue
