Feature: User can manage patient's consultations

  Scenario: Listing consultations
    Given Ada is a patient with consultations
    When I open her consultations page
    Then I see her consultations

  Scenario: Creating a consultation
    Given Ada is a patient
    When I open create consultation page
    And I input consultation info
    Then I see a success message
