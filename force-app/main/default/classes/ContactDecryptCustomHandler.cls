/***************
 * This ContactDecryptCustomHandler is for the customContactExtPage.page and does the following operation ->
 *      1. Decryptes the encrypted Id from the URL and shows the data of the Contact
***************/

public with sharing class ContactDecryptCustomHandler {
    public Contact contact{get;set;}

    public ContactDecryptCustomHandler() 
    { 
        contact= new Contact();
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
        else{
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
        List<contact> contactListToDisplay= [Select Id, Name, Email from Contact where Id =: decryptId LIMIT 1];
        if(!contactListToDisplay.isEmpty())
        {
            contact=contactListToDisplay[0];
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'NO CONTACT DATA AVAIALABLE. THANKYOU'));
        }

        }
        catch(Exception e)
        {
            System.debug('Decryption Failed'+e.getMessage());
        }
    }
}