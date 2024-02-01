/***************
 * This handler class is for ContactTrigger.apxt and does the following operations:
 * 1. ContactTriggerHandlerMethod() ->
 *      Encodes the contact Id and stores it in a custom field name Encrypted_Contact_Id__c.
 *      Creates an URL with the encrypted Id.
 *      Sends email with a list of encrypted URLS
 *      Does not send email anymore
 ***************/


public with sharing class ContactTriggerHandler 
{
    public static String passKey;
    public static String encData;
    
    public static void ContactTriggerHanlderMethod(List<Contact> contacts)
    {
       
        List<Contact> contactList= [SELECT id, Encrypted_Contact_Id__c, Mailing_URL__c FROM Contact where id =: contacts];
        List<Contact> contoadd= new List<Contact>();
        List<String> pageUrlList= new List<String>();
        String secretKey;

        
        //use a secret key and retrieve it from the metadata using metadata methods
        List<Encryption_Key__mdt> encryptionMdtList= Encryption_Key__mdt.getAll().values();
        if(encryptionMdtList[0].label != NULL)
        {
            secretKey= encryptionMdtList[0].Key__c;
        }


        for(Contact con: contactList)
        {
            //data to encrypt
            String conId= con.Id;
            Blob data= Blob.valueOf(conId);

            //generate the key in blob form
			Blob key= EncodingUtil.base64Decode(secretKey);
            System.debug('Key is ---> '+key);

            //encrypt the data
			Blob encryptedData=crypto.encryptWithManagedIV('AES128', key,data);
			System.debug('Encrypted Data ---> '+EncodingUtil.base64Encode(encryptedData));

            //copy the encrypted data to the custom field in contact with proper UTF-8 padding
            String encodeWithContactId= EncodingUtil.base64Encode(encryptedData);
            String encodeWithPadding = EncodingUtil.urlEncode(encodeWithContactId,'UTF-8');
            con.Encrypted_Contact_Id__c=encodeWithPadding;
            contoadd.add(con); 
        }

        System.debug('Encrypted Page URL List is ---> '+pageUrlList);

        //update the contact with the encrypted Data in the custom field
        if(!contoadd.isEmpty())
        {
            try{
                List<Database.SaveResult> updateContacts= Database.update(contoadd, true);
                for(Database.SaveResult sr: updateContacts)
                {
                    if(sr.isSuccess())
                    {
                        System.debug('Updation Successful ---> '+sr.getId());
                    }
                    else{
                        for(Database.Error er: sr.getErrors())
                        {
                            System.debug('Error in updating contact ---> '+er.getMessage());
                        }
                    }
                }
            }
            catch(Exception e)
            {
                System.debug('An Error occured ---> '+e.getMessage());
            } 
        }
    }
}