import { LightningElement, api } from 'lwc'; //api makes a var publicly accessable across all components

export default class PaginationComp extends LightningElement {
    totalContactRecords
    visibleContactRecords
    totalAccountRecords
    visibleAccountRecords
    accountRecordSize=5;
    contactRecordSize=5;
    currentPage=1;
    totalPage;


    get records(){
        return this.visibleContactRecords;
    }

    @api 
    set records(data){ //whenever sending data from child to parent
        if(data)
        {
            this.totalContactRecords= data;
            this.totalPage=Math.ceil(data.length/this.contactRecordSize);
            this.passContactRecords();
        }
    
    }

    get records(){
        return this.visibleAccountRecords;
    }

    // @api 
    // set records(data)
    // {
    //     if(data)
    //     {
    //         this.totalAccountRecords=data;
    //         this.totalPage=Math.ceil(data.length/this.accountRecordSize);
    //         this.passAccountRecords();
    //     }
    // }



    nextHandler()
    {
        if(this.currentPage< this.totalPage)
        {
            this.currentPage = this.currentPage +1;
            this.passContactRecords();
        }

    }

    previousHandler()
    {
        if(this.currentPage>1)
        {
            this.currentPage=this.currentPage -1;
            this.passContactRecords();
        }
    }

    passContactRecords()
    {
        const start = (this.currentPage-1)*this.contactRecordSize;
        const end = this.currentPage * this.contactRecordSize;
        this.visibleContactRecords = this.totalContactRecords.slice(start,end);
        this.dispatchEvent(new CustomEvent('sliced',{ //to send data to parent always need an event, so create a custom event
            detail:{
                records:this.visibleContactRecords
        }}));
    }

}