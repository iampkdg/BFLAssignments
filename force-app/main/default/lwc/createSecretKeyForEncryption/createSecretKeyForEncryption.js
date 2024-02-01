/***************
 * This component performs the following operations
 *      1. Checks for the Profile of the Current User(apex class -> GetCurrentUserDetails) and if Admin then shows a button on the HTML
 *      2. Creates a new key(apex class -> UpdateCustomerMetadataSecretKey) on a button click
 *      3. Runs a Batch Class(apex class ->StartBatchJobUtil.cls ->ContactFieldUpdationBatch.cls) that updates all the Contacts with the new Encrypted keys
 **************/

import { LightningElement, wire, track } from 'lwc';
import getProfileName from '@salesforce/apex/GetCurrentUserDetails.getProfileName';
import updateRecord from '@salesforce/apex/UpdateCustomMetadataSecretKey.updateRecord';
import startContactEncryptionBatch from '@salesforce/apex/StartBatchJobUtil.startContactEncryptionBatch';


export default class CreateSecretKeyForEncryption extends LightningElement {

    @track data;
    showButton=false;

    //used for checking if the current profile is System Admin
    @wire(getProfileName)
    wiredData({data,error}){
        if(data)
        {
            this.data= data;
            if(this.data == true)
            {
                this.showButton= true;
            }
        }
        else{
            this.showButton=false;
        }
    
    }
    
    //used to call the Apex that generates the key
    handleUpdate(){
        console.log('Key Generation Starts');
        return updateRecord().then(result=>{
            alert('Secret Key created',result);
            return startContactEncryptionBatch();

        })
        .then(batchResult =>{
            alert('Batch Started Successfully',batchResult);
        })
        .catch(error =>{
            alert('Secret key not Created',error);

        });
    }

}