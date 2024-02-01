/*******
 * This class does the following operations
 *      1. getRelatedContactEmail() -> Accepts the quoteId from the LWC sendEmailtoContactfromQuote.js and sends email to the contact
 ********/

public with sharing class QuoteDetailsController 
{
   @AuraEnabled(cacheable= true)
   public static void getRelatedContactEmail(Id quoteId)
   {
    try 
    {
        //Query out the Quote
        List<Quote> quoteList= [Select Id, Name, Contact.Email, Contact.Id from Quote where Id =:quoteId];
        
        //Query out the related Contacts
        List<Contact> conList=[SELECT Id, Mail_URL__c from Contact where Id =:quoteList[0].Contact.Id];

        //Start Sending the Email
        List<Messaging.SingleEmailMessage> sendMail= new List<Messaging.SingleEmailMessage>();
        EmailTemplate et= [SELECT Id, Body, Subject FROM EmailTemplate WHERE Name ='Email']; //retreiving the custom Email Template
        String[] toAddress= new String[]{quoteList[0].Contact.Email};
        Messaging.SingleEmailMessage mail= new Messaging.SingleEmailMessage();
        mail.setTemplateId(et.id);
        mail.setTargetObjectId(conList[0].id);
        mail.setSaveAsActivity(false);
        sendMail.add(mail);
        Messaging.sendEmail(sendMail);
    }
    catch (Exception e) 
    {
        System.debug('Error occured --> '+e.getMessage());
        //return null;
    }
   }
}