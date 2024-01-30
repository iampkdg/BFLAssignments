import { LightningElement, track } from 'lwc';

export default class Parent2 extends LightningElement {
    @track

    valFromChildComp;
    blablaHandler(event)
    {
        alert(event.detail);
        this.valFromChildComp=event.detail;
    }
}