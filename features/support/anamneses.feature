Feature: User can manage the patients' anamnesis

  Scenario: Create anamnesis
    Given Ada is a patient
     When I open create anamnesis page
     And I input Ada's anamnesis
     Then I see a confirmation message
