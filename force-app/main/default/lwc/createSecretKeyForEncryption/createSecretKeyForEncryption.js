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

    @track selectedSecretKeyLength;
    secretKeyLengthOptions = [
        { label: '128 bits', value: '128' },
        { label: '192 bits', value: '192' },
        { label: '256 bits', value: '256' },
    ];

    handleSecretKeyLengthChange(event){
        this.selectedSecretKeyLength= event.detail.value;
        //console.log('Alog -->',this.selectedSecretKeyLength);
    }

    
    //used to call the Apex that generates the key
    handleUpdate(){
        console.log('Key Generation Starts');
        console.log('Algo -->',this.selectedSecretKeyLength);
        // Verify the type and value of this.selectedSecretKeyLength
        console.log('Type of selectedSecretKeyLength:', typeof this.selectedSecretKeyLength);

        const secretKeyLengthInteger = parseInt(this.selectedSecretKeyLength, 10);
        console.log('Type of selectedSecretKeyLength:',typeof secretKeyLengthInteger);


        return updateRecord({algo: secretKeyLengthInteger}).then(result=>{
            alert('Secret Key created',result);
            return startContactEncryptionBatch();

        })
        .then(batchResult =>{
            alert('Batch Started Successfully',batchResult);
        })
        .catch(error =>{
            alert('Secret key not Created',error.detail);

        });
    }

}