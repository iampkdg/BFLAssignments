/**********
 * This class does the following
 *      1.startContactEncryptionBatch() -> calls the Batch class ContactFieldUpdationBatch.cls
 **********/
public with sharing class StartBatchJobUtil 
{
    @AuraEnabled
    public static void startContactEncryptionBatch(){
        try 
        {
            Database.executeBatch(new ContactFieldUpdationBatch(),200);
        } 
        catch (Exception e) 
        {
            System.debug('The Batch Job has failed to begun -> '+e.getMessage());
        }
    }
}