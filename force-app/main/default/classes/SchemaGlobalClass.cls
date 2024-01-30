public class SchemaGlobalClass {
    
    @AuraEnabled
    public static void SchemaExample(Id recordId)
    {
        // Define the object API name for which you want to retrieve child objects and their required fields
        String objectApiName = 'Account'; // Replace with the API name of your target object

        // Define the API names of the specific child objects you want to retrieve
        Set<String> specificChildObjects = new Set<String>{'Contacts', 'Opportunities'}; // Replace with the API names of your specific child objects

        // Get the Schema Describe for the target object
        Schema.DescribeSObjectResult objectDescribe = Schema.getGlobalDescribe().get(objectApiName).getDescribe();

        // Get the child relationships (related lists) for the target object
        List<Schema.ChildRelationship> childRelationships = objectDescribe.getChildRelationships();

        // Create a new Account to clone
        Account originalAccount = [SELECT Id, Name, BillingCity, BillingState FROM Account WHERE Id =: recordId LIMIT 1]; // Replace 'YourAccountId' with the Id of the Account you want to clone

        // Clone the original Account
        Account clonedAccount = originalAccount.clone(false, true, false, false);

        // Clear the Id to create a new record
        clonedAccount.Id = null;

        // Insert the cloned Account
        Database.SaveResult sr = Database.insert(clonedAccount, false);

        // Check if the insertion was successful
        if (sr.isSuccess()) 
        {
            System.debug('Cloned Account Id: ' + clonedAccount.Id);
            
            // Iterate through the child relationships to get the required fields for each specified child object
            for (Schema.ChildRelationship childRelationship : childRelationships) 
            {
                Schema.DescribeSObjectResult childObjectDescribe = childRelationship.getChildSObject().getDescribe();
                
                // Check if the child object is one of the specified child objects
                if (specificChildObjects.contains(childObjectDescribe.getName())) 
                {
                    // Get the required fields for the child object
                    List<String> requiredFields = new List<String>();
                    for (Schema.SObjectField childField : childObjectDescribe.fields.getMap().values()) 
                    {
                        Schema.DescribeFieldResult childFieldDescribe = childField.getDescribe();
                        if (childFieldDescribe.isNillable() && !childFieldDescribe.isDefaultedOnCreate()) 
                        {
                            requiredFields.add(childFieldDescribe.getName());
                        }
                    }
                    
                    // Query the required fields for the child object related to the original Account
                    String queryFields = String.join(requiredFields, ',');
                    String queryString = 'SELECT ' + queryFields + ' FROM ' + childObjectDescribe.getName() + ' WHERE AccountId = :originalAccount.Id';
                    List<SObject> relatedObjects = Database.query(queryString);
                    
                    // Clone and relate the child objects to the cloned Account
                    List<SObject> clonedRelatedObjects = new List<SObject>();
                    for (SObject relatedObject : relatedObjects) 
                    {
                        SObject clonedRelatedObject = relatedObject.clone(false, true, false, false);
                        clonedRelatedObject.put('AccountId', clonedAccount.Id);
                        clonedRelatedObjects.add(clonedRelatedObject);
                    }
                    
                    // Insert the cloned related objects
                    Database.SaveResult[] relatedSrList = Database.insert(clonedRelatedObjects, false);
                    for (Database.SaveResult relatedSr : relatedSrList) 
                    {
                        if (relatedSr.isSuccess()) 
                        {
                            System.debug('Cloned ' + childObjectDescribe.getName() + ' Id: ' + relatedSr.getId());
                        }
                        else
                        {
                            for (Database.Error error : relatedSr.getErrors()) 
                            {
                                System.debug('Error creating ' + childObjectDescribe.getName() + ': ' + error.getStatusCode() + ': ' + error.getMessage());
                            }
                        }
                    }
                }
            }
        } 
        else 
        {
            for (Database.Error error : sr.getErrors()) 
            {
                System.debug('Error creating Account: ' + error.getStatusCode() + ': ' + error.getMessage());
            }
        }

    }

}