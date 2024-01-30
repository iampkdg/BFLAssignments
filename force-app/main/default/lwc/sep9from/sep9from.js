import { api, LightningElement } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';

export default class Sep9from extends NavigationMixin 
{
    @api recordId;
    myData;
    myDataHandler(event)
    {
        this.myData=event.target.value;

    }
    destinationComphandler()
    {

        var target_destination={
            componentDef : 'c:Sep9destination',
            attributes :{
                Id: this.recordId,
                md: this.myData
            }
        }
        this[NavigationMixin.Navigate]({
            type: 'standard_webPage',
            attributes : {
                url : 'one/one-app#' + btoa(JSON.stringify(target_destination))
            }
        });
    }
}