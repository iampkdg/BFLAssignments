import { api, LightningElement, track } from 'lwc';

export default class Details extends LightningElement {
@track
valFromParent_fname;
@track
valFromParent_lname;
@track
valFromParent_city;


    @api
    getDetails(value)
    {
        alert(value.fname+'   '+value.lname+'   '+value.city);
        this.valFromParent_city=value.city;
        this.valFromParent_fname=value.fname;
        this.valFromParent_lname=value.lname;
    }

}