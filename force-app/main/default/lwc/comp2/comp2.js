import { LightningElement } from 'lwc';

export default class Comp2 extends LightningElement {
    myname='';
    nameHandler(event)
    {
        this.myname=event.target.value;
        console.log(this.myname);

    }
}