Feature: User can manage diseases

  Background:
    Given I am a logged user

  Scenario: List diseases
    Given the following diseases:
      | code | name      |
      | D001 | Disease 1 |
      | D002 | Disease 2 |
    When I open diseases page
    Then I see "Disease 1"
    And I see "Disease 2"

  Scenario: Create a disease
    When I open create disease page
    And I input disease information
    Then I see a success message

  Scenario: Update a disease
    Given Flu is a disease
    When I open edit disease page
    And I input disease information
    Then I see a success message

  Scenario: Search for diseases
    Given the following diseases:
      | code | name      |
      | D001 | Disease 1 |
      | D002 | Disease 2 |
    When I open diseases page
    And I query for "Disease 1"
    Then I see "Disease 1"
    But I don't see "Disease 2"
