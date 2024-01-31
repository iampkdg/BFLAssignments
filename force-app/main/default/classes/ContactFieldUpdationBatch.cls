/********************
 * This batch class performs the following operation
 * 1. Updates the Contact's custom field Encrypted_Contact_Id__c with the particular contacts Id in encrypted form
 * 2. Sends email to a receiver with list of Encrypted URL's
 ********************/

public with sharing class ContactFieldUpdationBatch implements Database.Batchable<SObject>, Database.Stateful, Schedulable
{
    List<String> pageUrlList = new List<String>();

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

            //copy the encrypted data to the custom field in contact
            con.Encrypted_Contact_Id__c= EncodingUtil.base64Encode(encryptedData);
            contoadd.add(con); 

            //copy the encrypted Id in another variable for further use
            encData=con.Encrypted_Contact_Id__c;

            //create the URL for the VF Page
            //Encode with proper Characters
            String encodedContactId= EncodingUtil.urlEncode(encData,'UTF-8');

            //create the custom URL with the VF page name
            String vfPageURL= '/apex/customContactExtPage?encryptId='+encodedContactId;
            pageUrlList.add(vfPageURL);
        }
        System.debug('Page URL List is --> '+pageUrlList);
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
        //construct the HTML body
        String htmlBody = '<html><body><p>The URLs are provided below.</p>';
        htmlBody += '<ul>';
        for (String url : pageUrlList) 
        {
            htmlBody += '<li>' + url + '</li>';
        }
        htmlBody += '</ul></body></html>';

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'pankaj.dasgupta@theblueflamelabs.com'};
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Encrypted URLs');
        mail.setSubject('Hi, you have the list of the page URLS');
        mail.setHtmlBody(htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        System.debug('Mail Sent');
    }
}
