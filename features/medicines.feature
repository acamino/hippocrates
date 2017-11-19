Feature: User can manage medicines

  Background:
    Given I am a logged user

  Scenario: Listing medicines
    Given the following medicines:
      | name        | instructions             |
      | Ibuprofen   | Ibuprofen instructions   |
      | Paracetamol | Paracetamol instructions |
    When I open medicines page
    Then I see "Ibuprofen"
    And I see "Paracetamol"

  Scenario: Creating a medicine
    When I open create medicine page
    And I input medicine information
    Then I see a success message

  Scenario: Updating a medicine
    Given Paracetamol is a medicine
    When I open edit medicine page
    And I input medicine information
    Then I see a success message

  Scenario: Search for medicines
    Given the following medicines:
      | name        | instructions             |
      | Ibuprofen   | Ibuprofen instructions   |
      | Paracetamol | Paracetamol instructions |
    When I open medicines page
    And I query for "Ibuprofen"
    Then I see "Ibuprofen"
    But I don't see "Paracetamol"
