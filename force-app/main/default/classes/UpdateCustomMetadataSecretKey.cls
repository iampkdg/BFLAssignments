/***************
 *This class updates a Custom Metadata type named Encryption_Key__mdt ->
 *      1. Updates a custom field Named Key__c with a key used for encryption
***************/

public with sharing class UpdateCustomMetadataSecretKey {

    @AuraEnabled
    public static void updateRecord()
    {
        //generate key 
        Blob secretKey= Crypto.generateAesKey(128);
        String key= EncodingUtil.base64Encode(secretKey);
        System.debug('Key is ---> '+key);

        //fetch records
        List<Encryption_Key__mdt> metaList= Encryption_Key__mdt.getAll().values();
        System.debug(metaList[0].key__c);

        
        if(metaList[0].label != NULL)
        {
            //instance of the record
            Metadata.CustomMetadata mdata=new Metadata.CustomMetadata();
            mdata.fullName='Encryption_Key.'+metaList[0].DeveloperName;
            mdata.label=metaList[0].MasterLabel;

            //instance of the value
            Metadata.CustomMetadataValue mvalue= new Metadata.CustomMetadataValue();
            mvalue.field= 'Key__c';
            mvalue.value= key;
            System.debug('New Value of Key is ---> '+mvalue.value);

            //add the values to the record
            mdata.values.add(mvalue);
            System.debug(mdata);

            //instance of the metadata container
            Metadata.DeployContainer container= new Metadata.DeployContainer();
            container.addMetadata(mdata);

            //enqueue for deployment
            Id jobId;
            jobId= Metadata.Operations.enqueueDeployment(container, null);
            System.debug(jobId);
        }
    } 
}
