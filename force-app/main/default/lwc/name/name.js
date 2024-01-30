import { LightningElement } from 'lwc';

export default class Name extends LightningElement {
    inputFname;
    inputLname;
    inputCity;

    inputFnameHandler(event)
    {
        this.inputFname=event.target.value;
    }
    inputLnameHandler(event){

        this.inputLname=event.target.value;
    }
    inputCityHandler(event){
        
        this.inputCity=event.target.value;
    }
    addData()
    {
        var chldcomp=this.template.querySelector('c-details');
        var value={'fname':this.inputFname,
                    'lname':this.inputLname,
                    'city':this.inputCity
                }
        chldcomp.getDetails(value);
    }
}