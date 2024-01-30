import { LightningElement, api } from 'lwc';
import SchemaExample from '@salesforce/apex/SchemaGlobalClass.SchemaExample';

export default class CloneAcc extends LightningElement {

    _recordId;
    navigateQuoteId;


    //used for quick action. 
    @api get recordId(){
        return this._recordId;
    }
    set recordId(recordId){
        if (recordId !== this._recordId) {
            this._recordId = recordId;
       }
    }

    handleClone(){
        SchemaExample({recordId: this.recordId})
        .then(result=>{
            console.log('Clonned', result);

        }).catch(error =>{
            console.error('Error', error);
        })

    }
    

}