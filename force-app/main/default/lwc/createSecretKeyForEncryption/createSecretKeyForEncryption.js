/***************
 * This component performs the following operations
 *      1. Checks for the Profile of the Current User(apex class -> GetCurrentUserDetails) and if Admin then shows a button on the HTML
 *      2. Creates a new key(apex class -> UpdateCustomerMetadataSecretKey) on a button click
 **************/

import { LightningElement, wire, track } from 'lwc';
import getProfileName from '@salesforce/apex/GetCurrentUserDetails.getProfileName';
import updateRecord from '@salesforce/apex/UpdateCustomMetadataSecretKey.updateRecord';

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
        updateRecord().then(result=>{
            alert('Secret Key created',result);

        }).catch(error =>{
            alert('Secret key not Created',error);

        });
    }

}