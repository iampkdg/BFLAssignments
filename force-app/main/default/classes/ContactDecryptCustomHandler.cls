public with sharing class ContactDecryptCustomHandler {
    public Contact contact{get;set;}

    public ContactDecryptCustomHandler() { 
        contact= new Contact();
    }

    public void retrieveContact()
    {
        //retrieve the secret key from the custom metadata
        Encryption_Key__mdt encryptionKey = [SELECT Id, Label FROM Encryption_Key__mdt LIMIT 1];
        String secretKey= encryptionKey.Label;

        //retrieve the encryptedId from the PageURL
        String encryptedContactId= ApexPages.currentPage().getParameters().get('encryptId');
        System.debug('Encrypted Contact Id is ----> '+encryptedContactId);

        //Start the decryption
        Blob decryptedId= EncodingUtil.base64Decode(encryptedContactId);
        Blob key= EncodingUtil.base64Decode(secretKey);
        Blob decrypt = Crypto.decryptWithManagedIV('AES128',Key, decryptedId);

        //convert the Blob to string
        String decryptId= decrypt.toString();
        System.debug(decryptId);

        //query out the contacts details from the decrypted ID
        contact= [Select Id, Name, Email from Contact where Id =: decryptId LIMIT 1];
    }
}