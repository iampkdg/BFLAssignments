@isTest
private class MarkReadContactContollerTest {

    @isTest static void testMarkAsRead() {
        // Create a contact record with 'Is_Contact_Mark__c' as false
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com',
            Is_Contact_Mark__c = false
        );
        insert testContact;

        // Get the standard set controller
        ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, Name, Email, Is_Contact_Mark__c FROM Contact WHERE Id = :testContact.Id]));
        

        // Initialize the MarkReadContactContoller with the standard set controller
        MarkReadContactContoller mrcController = new MarkReadContactContoller(stdController);

        // Call the markAsRead method
        mrcController.markAsRead();

        // Query the contact record to verify if it was updated
        Contact updatedContact = [SELECT Id, Name, Email, Is_Contact_Mark__c FROM Contact WHERE Id = :testContact.Id];

        // Verify if the contact record was updated
        System.assertEquals(true, updatedContact.Is_Contact_Mark__c, 'The contact record should have been updated');
    }
}