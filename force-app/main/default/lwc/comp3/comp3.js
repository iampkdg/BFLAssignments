import { LightningElement, track } from 'lwc';

export default class Component3 extends LightningElement {
    @track
    batchInfoArray = [
        {
            batchID: 201,
            batchName: 'SFDC Batch 1',
            batchCount: 30,
        },
        {
            batchID: 202,
            batchName: 'SFDC Batch 2',
            batchCount: 20,
        },
        {
            batchID: 203,
            batchName: 'SFDC Batch 3',
            batchCount: 33,
        },
    ];
    bID;
    bName;
    bCount;
    bIdHandler(event){
        this.bID = Number(event.target.value);
    }
    bNameHandler(event){
        this.bName = event.target.value;
    }
    bCountHandler(event){
        this.bCount = Number(event.target.value);
    }
    addBatchHandler(){
        this.batchInfoArray.push({
            'batchID':this.bID,
            'batchName':this.bName,
            'batchCount':this.bCount
        })
        console.log(this.batchInfoArray)
    }
    index;
    delBatchHandler(event){
        this.index = event.target.value;
        this.batchInfoArray.splice(this.index,1);
    }
}