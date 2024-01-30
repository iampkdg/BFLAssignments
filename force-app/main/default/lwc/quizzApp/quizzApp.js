import { LightningElement } from 'lwc';

export default class QuizzApp extends LightningElement {

    correctanswers=0
    isSumbmitted = false

    selectedOption={}

    myquestions =[
        {
            id:'Question 1',
            question: "What is the Capital of India?",
            answers:{
                a:"Delhi",
                b:"Washington",
                c:"Turkey"
            },

            correctanswer:'a'


        }, 
        {
            id:'Question 2' ,
            question: "When is the Independence day in India?",
            answers:{
                a:"14th Aug",
                b:"15th Aug",
                c:"26th Jan"
            },

            correctanswer:'b'


        },
        {
            id:'Question 3' ,
            question: "Is Java 100% OOPS Language",
            answers:{
                a:"True",
                b:"False",
                c:"Maybe"
            },

            correctanswer:'b'


        }
        
    ]

     //for storing answers

    // get allNotSelected(){
    //     console.log(Object.keys(this.selectedOption).length)
    //     console.log(this.myquestions.length)
    //     return !(Object.keys(this.selectedOption).length === this.myquestions.length)
    // }

    changeHandler(event){
        //console.log('value',event.target.value)
        //console.log('name', event.taget.name)
        
        const {name,value} = event.target
        this.selectedOption={...this.selectedOption, [name]:value}


    }

    submitHandler(event){
        event.preventDefault()// this is because form always refreshes the data
        this.isSumbmitted= true
        let correct  = this.myquestions.filter(item=>this.selectedOption[item.id] === item.correctanswer)
        this.correctanswers = correct.length
        console.log(correct.length)
        console.log(this.correctanswers)


    }

    resetHandler(event){

        this.selectedOption={}
        this.correctanswers = 0
    }
}