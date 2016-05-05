Feature: User can manage the patients' anamnesis

  Scenario: Create anamnesis
    Given Bob is an existing patient
     When I go to the new anamnesis page
      And I input Bob's anamnesis
     Then I see a confirmation message
