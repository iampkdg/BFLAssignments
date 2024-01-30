import { LightningElement } from 'lwc';

export default class Child2 extends LightningElement {
    data;
    dataHandler(event)
    {
        this.data=event.target.value;
    }
    sendContentHandler(event)
    {
        var myevent=new CustomEvent(blabla,{
            detail: this.data
        });
        this.dispatchEvent(myevent);
    }
}