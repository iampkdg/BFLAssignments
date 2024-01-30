import { LightningElement,wire,track,api } from 'lwc';
import getAccList from '@salesforce/apex/dataController.getAccList';

var actioning =[{
    label:'delete',
    name:'delete',
    iconName:'action:delete'
}];

const COLUMNS=[
    { label: 'Name', fieldName: 'Name',editable:true},
    {label: 'AccountNumber', fieldName: 'AccountNumber',editable:true},
    {label: 'Phone', fieldName: 'Phone',editable:true},
    {label: 'Type', fieldName:'Type',
     type:'picklist',typeattributes:{
         options:[
             {label:'hot',value:'hot'},
             {label:'cold',value:'cold'}
         ]
     }
     ,editable:true}, 
    {type:'action', typeattributes:{rowActions:actioning}}
]
export default class dataTable extends LightningElement 
{
     tableData
    Columns=COLUMNS
    @wire (getAccList)
    accountHandler({data,error})
    {
        if(data)
        {
            this.tableData=data
        }
        if(error)
        {
            console.log(error)
        }

    }
}