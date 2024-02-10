/********* 
 * This class does the following:
 *      1. Is added to the VF sendEmailToContact.page , this page is Related to List view button in the Contact
 *      2. Gets all the selected Contacts from the contacts page and sends them EMAIL of the Encrypted Id
**********/
public with sharing class SendEmailQuotesController {

    public ApexPages.StandardSetController setCon; 
    public List<Contact> contactList{get;set;}
    public Map<Id, Contact> contactMap{get;set;}

    public SendEmailQuotesController(ApexPages.StandardsetController stdController) 
    {

        setCon= stdController;
        contactList = (List<Contact>)stdController.getSelected();
        contactMap = new Map<Id, Contact>();
        for(Contact c: contactList)
        {
            contactMap.put(c.Id, c);
        }
    }

    public PageReference sendEmail()
    {

        Set<Id> contactIDSet= new Set<Id>();
        String emailAddress;
        String encryptedKey;
        try{
            //List out the Selected Contacts from the Page
            List<Contact> conList= [SELECT Id, Email, Mail_Url__c FROM Contact WHERE Id =: contactMap.keySet()];
            for(Contact c: conList)
            {
                List<Messaging.SingleEmailMessage> sendMail= new List<Messaging.SingleEmailMessage>();
                EmailTemplate et= [SELECT Id, Body, Subject FROM EmailTemplate WHERE Name ='Email']; //retreiving the custom Email Template
                String[] toAddress= new String[]{c.Email};
                Messaging.SingleEmailMessage mail= new Messaging.SingleEmailMessage();
                mail.setTemplateId(et.id);
                mail.setTargetObjectId(c.id);
                mail.setSaveAsActivity(false);
                sendMail.add(mail);
                Messaging.sendEmail(sendMail);
            }

        }catch(Exception e){
            System.debug('Error occured --> '+e.getMessage());

        }
        PageReference contactListView = new PageReference('/lightning/o/Contact/list');
        contactListView.setRedirect(true);
        return contactListView;
    }
}
