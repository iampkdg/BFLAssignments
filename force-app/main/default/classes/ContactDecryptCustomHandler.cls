/***************
 * This ContactDecryptCustomHandler is for the customContactExtPage.page and does the following operation ->
 *      1. Decryptes the encrypted Id from the URL and shows the data of the Contact
 *      2. Decryptes the URL and shows the related Quote
 *      3. Decryptes the URL and shows the related Quote Line Items
***************/

public without sharing class ContactDecryptCustomHandler 
{
    public Contact contact{get;set;}
    public List<QuoteLineItem> quoteLineItemDisplay {get;set;}
    public List<Quote> quoteDisplayList{get;set;}
    public Map<Id, List<QuoteLineItem>> quoteLineItemMap { get; set; }
    public String selectedQuoteIds { get; set; }
    public Boolean hideButton{get;set;}

    public ContactDecryptCustomHandler() 
    {   
        contact= new Contact();
        quoteLineItemDisplay =new List<QuoteLineItem>();
        quoteDisplayList= new List<Quote>();
        quoteLineItemMap = new Map<Id,List<QuoteLineItem>>();
        hideButton=false;
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
            
        }
        System.debug('Secret Key --> '+secretKey);

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

        Integer keyLenght= key.size();
        Integer keyLengthbits= keyLenght*8;
        Blob decrypt= Blob.valueOf('');
            if(keyLengthbits == 128){
                decrypt = Crypto.decryptWithManagedIV('AES128',Key, decryptedId);
            }
            else if(keyLengthbits == 192){
                decrypt = Crypto.decryptWithManagedIV('AES192',Key, decryptedId);
            }
            else if(keyLengthbits == 256){
                decrypt = Crypto.decryptWithManagedIV('AES256',Key, decryptedId);
            }

        //Blob decrypt = Crypto.decryptWithManagedIV('AES128',Key, decryptedId);

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
        List<Quote> quoteData=[SELECT Id, Name, Email, IsSyncing, OpportunityId, ContactId from Quote Where ContactId =: contactId];
        Set<Id> quoteIds= new Set<Id>();
        for(Quote q: quoteData)
        {
            quoteIds.add(q.Id);
        }

        //get the QuoteLineItem for the quote
        Map<Id, List<QuoteLineItem>> latestQuoteLineItemMap = new Map<Id, List<QuoteLineItem>>();
        for(QuoteLineItem qli:[SELECT Id, TotalPrice, Product2Id ,Quantity, UnitPrice, QuoteId from QuoteLineItem WHERE QuoteId =: quoteIds])
        {
            if(!latestQuoteLineItemMap.containsKey(qli.QuoteId))
            {
                latestQuoteLineItemMap.put(qli.QuoteId, new List<QuoteLineItem>());
            }
            latestQuoteLineItemMap.get(qli.QuoteId).add(qli);
        }

        //send data to VF Page
        if(contactListToDisplay!= Null)
        {
            contact=contactListToDisplay[0];
            quoteDisplayList= quoteData;
            for(Quote q: quoteDisplayList)
            {
            quoteLineItemMap.put(q.Id, latestQuoteLineItemMap.get(q.Id));
            }
            System.debug('Quote Line Item Map --> '+quoteLineItemMap);
            
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

    //method to Sync Quote With Opportunity
    public PageReference selectQuote()
    {
        System.debug('Entered Start Sync method');
        System.debug('Selected Ids are --> '+selectedQuoteIds);
        if(selectedQuoteIds!= NULL)
        {
            Quote quotesToUpdate= [Select Id, IsSyncing, OpportunityId from Quote where Id =: selectedQuoteIds LIMIT 1];
            if (quotesToUpdate.OpportunityId != null) 
            {
                    Opportunity relatedOpportunity = [SELECT Id, Name, SyncedQuoteId FROM Opportunity WHERE Id = :quotesToUpdate.OpportunityId LIMIT 1];
            
                    // Quote is synced with an Opportunity
                    if (relatedOpportunity != null) 
                    {
                        relatedOpportunity.SyncedQuoteId = quotesToUpdate.Id;
                        Database.update(relatedOpportunity);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'QUOTE SYNCED, PLEASE REFRESH PAGE TO SEE THE STATE OF SYNC!!!'));
                    }
            }
            else if(quotesToUpdate.OpportunityId == null)
            {
                System.debug('No Opportunity Found');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'NO OPPORTUNITY FOUND FOR THE QUOTE'));
            }
        }
        return null;
    }
}