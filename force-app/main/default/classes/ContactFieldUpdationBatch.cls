/********************
 * This batch class performs the following operation
 * 1. Updates the Contact's custom field Encrypted_Contact_Id__c with the particular contacts Id in encrypted form
 * 2. Sends email to a receiver with list of Encrypted URL's
 * 3. Does not send email anymore
 ********************/

public with sharing class ContactFieldUpdationBatch implements Database.Batchable<SObject>, Schedulable
{
    //method to query the records
    public Database.QueryLocator start (Database.BatchableContext bc)
    {
        return Database.getQueryLocator('Select ID, Name,Encrypted_Contact_Id__c from Contact');
    }

    //method to make the batch schedulable
    public void execute(SchedulableContext sc)
    {
        ContactFieldUpdationBatch batch= new ContactFieldUpdationBatch();
        Database.executeBatch(batch, 200);
    }

    //method to perform logic 
    public void execute(Database.BatchableContext bc, List<Contact> contacts)
    {
        String secretKey;
        String encData;
        List<Contact> contoAdd= new List<Contact>();

        //use a secret key and retrieve it from the metadata using metadata methods
        List<Encryption_Key__mdt> encryptionMdtList= Encryption_Key__mdt.getAll().values();
        if(encryptionMdtList[0].label != NULL)
        {
            secretKey= encryptionMdtList[0].Key__c;
        }


        for(Contact con: contacts)
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
            encData= EncodingUtil.base64Encode(encryptedData);
            String encodedContactId= EncodingUtil.urlEncode(encData,'UTF-8');
            con.Encrypted_Contact_Id__c= encodedContactId;
            contoadd.add(con); 

        }

        //update the contact with the encrypted Data in the custom field
        if(!contoadd.isEmpty())
        {
            try{
                List<Database.SaveResult> updateContacts= Database.update(contoadd, true);
                System.debug('Updation Size ---> '+updateContacts.size());
                for(Database.SaveResult sr: updateContacts)
                {
                    if(sr.isSuccess())
                    {
                        System.debug('Updation Successful');
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

    //finish method to send email with the Page URL
    public void finish(Database.BatchableContext bc)
    {
        System.debug('Batch Run Complete');
    }
}
