/*************
 * This class performs the following operations
 *      1. getProfileName()-> Checks if the name of the Profile is System Admin and returns in Boolean
 *************/
public with sharing class GetCurrentUserDetails 
{
    //method to check the profileName of the current user
    @AuraEnabled(cacheable= true)
    public static Boolean getProfileName()
    {
        try 
        {
            Id profileID= UserInfo.getProfileId();
            String profileName= [Select Id, Name from Profile where Id =: profileID].Name;
            if(profileName == 'System Administrator')
            {
                return true;
            }
            else
            {
                return false;
            }
            
        } 
        catch (Exception e) 
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
