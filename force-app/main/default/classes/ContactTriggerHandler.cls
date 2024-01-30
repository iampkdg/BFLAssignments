public with sharing class ContactTriggerHandler 
{
    public static String passKey;
    public static String encData;
    
    public static String ContactTriggerHanlderMethod(List<Contact> contacts)
    {
       
        List<Contact> contactList= [Select id, Encrypted_Contact_Id__c From Contact where id =: contacts];
        List<Contact> contoadd= new List<Contact>();
        
        //use a secret key stored in metadata
        Encryption_Key__mdt encryptionKey = [SELECT Id, Label FROM Encryption_Key__mdt LIMIT 1];
        String secretKey= encryptionKey.Label;
        System.debug('Secret Key is ----> '+secretKey);
        
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
        }
        //update the contact with the encrypted Data in the custom field
        update(contoadd);

        //Encode the Data properly along with Special Characters
        String encodedContactId= EncodingUtil.urlEncode(encData,'UTF-8');

        //create the custom URL with the VF page name
        String vfPageURL= '/apex/customContactExtPage?encryptId='+encodedContactId;
        System.debug('Encrypted Page URL is ---> '+vfPageURL);
        return vfPageURL;
    }
}

