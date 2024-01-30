import { LightningElement } from 'lwc';
import {loadStyle} from 'lightning/platformResourceLoader'
import fontawesome from '@salesforce/resourceUrl/fontawesome'

export default class MemoryGame extends LightningElement {

    cards=[
        {id:1 , listClass: "card", type:'diamond', icon:'fa fa-diamond'},
        {id:2 , listClass: "card", type:'anchor', icon:'fa fa-anchor'},
        {id:3 , listClass: "card", type:'bolt', icon:'fa fa-bolt'},
        {id:4 , listClass: "card", type:'cube', icon:'fa fa-cube'},
        {id:5 , listClass: "card", type:'leaf', icon:'fa fa-leaf'},
        {id:6 , listClass: "card", type:'bicycle', icon:'fa fa-bicycle'},
        {id:7 , listClass: "card", type:'bomb', icon:'fa fa-bomb'},
        {id:8 , listClass: "card", type:'plane', icon:'fa fa-paper-plane-o'},
        {id:9 , listClass: "card", type:'diamond', icon:'fa fa-diamond'},
        {id:10 , listClass: "card", type:'anchor', icon:'fa fa-anchor'},
        {id:11 , listClass: "card", type:'bolt', icon:'fa fa-bolt'},
        {id:12 , listClass: "card", type:'cube', icon:'fa fa-cube'},
        {id:13 , listClass: "card", type:'leaf', icon:'fa fa-leaf'},
        {id:14 , listClass: "card", type:'bicycle', icon:'fa fa-bicycle'},
        {id:15 , listClass: "card", type:'bomb', icon:'fa fa-bomb'},
        {id:16, listClass: "card", type:'plane', icon:'fa fa-paper-plane-o'}
    ]


    
    isFontCalled = false
    

    displayCard(event){
        let currCard = event.target
       
        alert(currCard.classlist.add("open", "show", "disabled"))
        //console.log(currCard)

    }








    renderedCallback()
    {
        if(this.isFontCalled){
            return
        }
        else{
            loadStyle(this, fontawesome+'/fontawesome/css/font-awesome.min.css').then(()=>{
                console.log('font loadaed')
            }).catch(error=>{
                console.error(error)
    
            })
            this.isFontCalled = true

        }
        
    }
}