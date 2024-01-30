import { LightningElement, track } from 'lwc';
import sep9save from '@salesforce/apex/Sep9Cls2.saveDetails';

export default class Comp5 extends LightningElement {
    sno;
    name;
    email;
    @track
    output;

    snoHandler(event){this.sno=event.target.value};
    nameHandler(event){this.name=event.target.value};
    emailHandler(event){this.email=event.target.value};
    saveHandler(event)
    {
        sep9save({
            mySno:this.sno,
            myName:this.name,
            myEmail:this.email
        }).then(resData=> {
            console.log(resData);
            this.output=resData;
        }).catch(error=>{
            console.log(error)
        });
    }
   
}