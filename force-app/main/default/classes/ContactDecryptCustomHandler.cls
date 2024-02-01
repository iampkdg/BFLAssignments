/***************
 * This ContactDecryptCustomHandler is for the customContactExtPage.page and does the following operation ->
 *      1. Decryptes the encrypted Id from the URL and shows the data of the Contact
 *      2. Decryptes the URL and shows the related Quote
 *      3. Decryptes the URL and shows the related Quote Line Items
***************/

public with sharing class ContactDecryptCustomHandler 
{
    public Contact contact{get;set;}
    public Quote quoteDisplay{get;set;}
    public List<QuoteLineItem> quoteLineItemDisplay {get;set;}

    public ContactDecryptCustomHandler() 
    { 
        contact= new Contact();
        quoteDisplay= new Quote();
        quoteLineItemDisplay =new List<QuoteLineItem>();
    }
    public void retrieveContact() 
    {
        String secretKey; 
        String checkValidEncryptString;

        //use a secret key and retrieve it from the metadata using metadata methods
        List<Encryption_Key__mdt> encryptionMdtList= Encryption_Key__mdt.getAll().values();
        if(encryptionMdtList[0].label != NULL)
        {
            secretKey= encryptionMdtList[0].Key__c;
        }
        else
        {
            System.debug('No Secret Key found');
            return; 
        }

        //retrieve the encryptedId from the PageURL
        String encryptedContactId= ApexPages.currentPage().getParameters().get('encryptId');
        System.debug('Encrypted Contact Id is ----> '+encryptedContactId);

        //check if encrypted Id is there in the URL
        if(String.isBlank(encryptedContactId))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'THE CONTACT DATA CANNOT BE DISPLAYED DUE TO UNAVAILABLE ID, PLEASE CONTACT ADMIN!!'));
        }
        //check if the Encrypted Id is valid
        checkValidEncryptString= encryptedContactId;
        checkValidEncryptString.replaceAll('=','');
        if(Math.mod(checkValidEncryptString.length(), 4)!= 0)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'THE URL IS NOT VALID!!! PLEASE ENTER A VALID URL'));
        }
    
        try
        {
        //Start the decryption
        Blob decryptedId= EncodingUtil.base64Decode(encryptedContactId);
        Blob key= EncodingUtil.base64Decode(secretKey);
        Blob decrypt = Crypto.decryptWithManagedIV('AES128',Key, decryptedId);

        //convert the Blob to string
        String decryptId= decrypt.toString();
        System.debug('Decrypted Contact Id ---> '+decryptId);

        //query out the contacts details from the decrypted ID
        List<Contact> contactListToDisplay= [Select Id, Name, Email from Contact where Id =: decryptId LIMIT 1];
        Set<Id> contactId= new Set<Id>();
        for(Contact con: contactListToDisplay)
        {
            contactId.add(con.Id);
        }
        System.debug('Contact Id ---> '+contactId);
        
        //query out the Quote Details for that specific Contact
        List<Quote> quoteData=[SELECT Id, Name, Email, ContactId from Quote Where ContactId =: contactId];
        if(contactListToDisplay!= Null)
        {
            contact=contactListToDisplay[0];
            quoteDisplay=quoteData[0];
            
            //get the QuoteLineItems for the respective Quote
            quoteLineItemDisplay= [SELECT ID, TotalPrice from QuoteLineItem where QuoteId =: quoteData[0].Id];
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'NO CONTACT DATA AVAIALABLE. THANKYOU'));
        }

        }
        catch(Exception e)
        {
            System.debug('Decryption Failed --> '+e.getMessage());
            System.debug('Cause of Failure --> '+e.getCause());
            System.debug('Error in Line Number --> '+e.getLineNumber());
        }
    }
}