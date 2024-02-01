/***********
 * This LWC is linked to a button on the Quote Record Page that sends email to the related Contact using the class 
 *          ->QuoteDetailsController.cls
 ***********/

import { LightningElement, api } from 'lwc';
import getRelatedContactEmail from '@salesforce/apex/QuoteDetailsController.getRelatedContactEmail';

export default class SendEmailtoContactfromQuote extends LightningElement 
{
    @api recordId;

    sendEmailHandler()
    {
        getRelatedContactEmail({quoteId: this.recordId})
        .then(result=>{
            alert('Email Sent Successfully');
            console.log('Success -->',result);
        }).catch(error=>{
            console.error('Get error -->',error)
        });
    }


}
