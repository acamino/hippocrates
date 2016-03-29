Feature: User can see a list of patients

  Scenario: Listing patients
    Given Reed and Sue are patients
    When I am on the patients page
    Then I see Reed and Sue
