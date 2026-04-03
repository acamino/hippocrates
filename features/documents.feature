Feature: User can manage consultation documents

  Scenario: Listing documents
    Given Ada has a consultation with documents
    When I open her documents page
    Then I see "Lab results"

  Scenario: Creating a document
    Given Ada has a consultation
    When I open create document page
    And I input document information
    Then I see "Documento creado correctamente"

  Scenario: Updating a document
    Given Ada has a consultation with documents
    When I open edit document page
    And I update document information
    Then I see "Documento actualizado correctamente"

  Scenario: Deleting a document
    Given Ada has a consultation with documents
    When I open her documents page
    And I delete the document
    Then I see "Documento eliminado correctamente"
