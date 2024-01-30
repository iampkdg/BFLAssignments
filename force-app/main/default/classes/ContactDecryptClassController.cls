public with sharing class ContactDecryptClassController 
{
    public Contact newContact { get; set; }
    public static String decryptedContactId {get;set;}
    public static Contact conList;
    
    private ApexPages.StandardController stdController; 

    public ContactDecryptClassController(ApexPages.StandardController standardController) 
    {
        Id conid;
        this.stdController= standardController;
        newContact= new Contact();
        newContact.Id= stdController.getId();
        conid= newContact.Id;
        if(newContact!= NULL)
        {
            conList = Database.query(
                'SELECT Id, Encrypted_Contact_Id__c,Key__c '+
                'FROM Contact WHERE '+
                'ID =: conid');
        }
    

    
        String encryptedKey = conList.Key__c;
        System.debug('Key is ---> '+encryptedKey);
        String encryptedId = conList.Encrypted_Contact_Id__c;
        String contactId= conList.Id;
        //ContactTriggerHandler.Decryption(contactId);

        Blob decrypt= (EncodingUtil.base64Decode(encryptedId));
        System.debug('Data to be decrepted ---> '+decrypt);
        Blob key= EncodingUtil.base64Decode(encryptedKey);
        System.debug('Key generated ---> '+key);
        
        // //Blob generateIv= Crypto.generateAesKey(128);
        Blob decrypted= Crypto.decryptWithManagedIV('AES128', key, decrypt);

        // System.debug('Decrypted Id ------> '+decrypted);
        
        decryptedContactId= decrypted.toString();
        System.debug('Decrypted Id -----> '+decryptedContactId);

        //return decryptedContactId;
    
    }   
}