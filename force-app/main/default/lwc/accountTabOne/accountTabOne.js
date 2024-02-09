import { LightningElement, api,track } from 'lwc';
import getAccountRecords from '@salesforce/apex/Store.getAccountRecords'

export default class AccountTabOne extends LightningElement {

    @api recId
    account
    
    @track accountColumn=[
        {
            label:'Name',fieldName:'Name' 
        },
        {
            label:'Phone', fieldName:'Phone'
        }
    ];
    

    connectedCallback(){
        this.loadAccountData()
        console.log('Record Id from Parent is',this.recId)
    }
    loadAccountData(){
        getAccountRecords({accountId: this.recId})
    .then(result =>{
        console.log('Result is',result)
        this.account = result
    }).catch(error=>{
        console.error('Error is',error);
    })
    }

    
}
