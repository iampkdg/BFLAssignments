import { LightningElement, api, track } from 'lwc';
import getContactsOnAccountId from '@salesforce/apex/Store.getContactsOnAccountId'

export default class ContactDetailsTab3 extends LightningElement {
    @api recId
    contact;

    @track contactColumn=[
        {
            label:'Name',fieldName:'Name' 
        },
        {
            label:'Phone', fieldName:'Phone'
        },
        {
            label:'Email', fieldName:'Email'
        }
    ];

    connectedCallback(){
        this.loadAccountHandler();
    }
    loadAccountHandler(){
        getContactsOnAccountId({getAccountRecords: this.recId})
        .then(result=>{
            this.contact=result
        }).catch(error=>{
            console.error(error)
        })
    }
}