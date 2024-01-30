import { api, LightningElement } from 'lwc';
import name from '@salesforce/schema/Sep9__c.Name';
import email from '@salesforce/schema/Sep9__c.Email__c';
import sno from '@salesforce/schema/Sep9__c.Sno__c'




export default class Ldc1 extends LightningElement {
    @api recordId;
    @api objectApiName;
    objectName;
    myFields =[name,email,sno];
    connectedCallback()
    {
        this.objectName=this.objectApiName;
    }
}