public with sharing class Store {
    @AuraEnabled(cacheable=true) 
    public static  List<Account> getAccountRecords(Id accountId)
    {
       
        List<Account> acc= [SELECT id, name, phone, Website, BillingAddress from Account where ID =: accountId with SECURITY_ENFORCED];
        return acc;
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactRecords()
    {
        List<Contact> con= new List<Contact>();
        System.debug('Number of contacts'+con.size());
        con= [select id, name, Email from Contact with SECURITY_ENFORCED limit 20];
        return con;
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsOnAccountId(Id getAccountRecords){
    
        List<Contact> conList=[SELECT Id, Name, Email from Contact where AccountId =: getAccountRecords];
        return conList;
    }

}