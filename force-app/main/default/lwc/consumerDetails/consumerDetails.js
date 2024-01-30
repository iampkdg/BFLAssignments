import { LightningElement,track, wire } from 'lwc'; //wire gets the data from apex to js
//import Store from '@salesforce/apex/Store.getAccountRecords'
import getContactRecords from '@salesforce/apex/Store.getContactRecords'
// import getAccountRecords from '@salesforce/apex/Store.getAccountRecords'

export default class ConsumerDetails extends LightningElement 
{

    visibleContactList;
    visibleAccountList;

    @track contactColunm=[
        {
            label:'Name', fieldName:'Name'
        },
        {
            label:'Email', fieldName:'Email'
        }
    ];
    @track accountColumn=[
        {
            label:'Name',fieldName:'Name'
        },
        {
            label:'Phone', fieldName:'Phone'
        }
    ];
@track contacts;
// @track account;

@wire(getContactRecords)contactsHandler({error,data})
{
    if(data)
    {
        this.contacts=data;
        console.log(data);
    }
    else if(error)
    {
        console.log(error);
    }

}

// @wire(getAccountRecords)accountHandler({error,data})
// {
//     if(data)
//     {
//         this.account=data;
//         console.log(data);
//     }
//     else if(error)
//     {
//         console.log(error);
//     }
// }

sliceHandler(event) //the event that came from child js to parent js than to parent html
{
    this.visibleContactList=[...event.detail.records]; //spread operator used to spread out the array here

}

// accountsliceHandler(event)
// {
//     this.visibleAccountList=[...event.detail.records];
// }

}