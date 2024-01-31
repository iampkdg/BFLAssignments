/***************
 * This handler class is for ContactTrigger.apxt and does the following operations:
 * 1. ContactTriggerHandlerMethod() ->
 *      Encodes the contact Id and stores it in a custom field name Encrypted_Contact_Id__c.
 *      Creates an URL with the encrypted Id.
 *      Sends email with a list of encrypted URLS
 ***************/


public with sharing class ContactTriggerHandler 
{
    public static String passKey;
    public static String encData;
    
    public static void ContactTriggerHanlderMethod(List<Contact> contacts)
    {
       
        List<Contact> contactList= [Select id, Encrypted_Contact_Id__c From Contact where id =: contacts];
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

        //send email with the List of URLS
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