public with sharing class GetAccountDetails 
{
    public static List<Account> getAccountDetails()
    {
        List<Account> accwithNoContacts = new List<Account>();
        Map<Id, Integer> accWithContacts = new Map<Id, Integer>();
        List<Account> accReturn= new List<Account>();

        List<Account> accList= [Select Id, Name , Phone, (Select id from Contacts) from Account];
        for(Account a: accList)
        {
            if(a.Contacts.isEmpty())
            {
                accwithNoContacts.add(a);
                
            }    
            else
            {
                accWithContacts.put(a.ID, a.Contacts.size());
               
            }
        }
        for (Id accountId : accWithContacts.keySet()) 
        {
            Account acc = new Account(Id = accountId);
            accReturn.add(acc);
        }

        // Add accounts with no contacts to the return list
        accReturn.addAll(accwithNoContacts);

        return accReturn;

    }
}