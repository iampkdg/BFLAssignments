import { LightningElement } from 'lwc';

export default class DesignQuizzApplication extends LightningElement {

    selected={}//for storing answers
    correctAnswers = 0
    isSubmit = false
    myQuestion=[{ 
        id: 'Question1',
        question: 'What is the new name of Raj Path?',
        answers:{
            a: 'Kartvya Path',
            b: 'I dont know!',
            c: 'India Path',
            d: 'Bharat Path'
        },
        correctAnswer: 'a'

    },
    {
        id: 'Question2',
        question: 'What is the new name of Ayodhya Railway Station?',
        answers:{
            a: 'Ayodhya Dham Railway Station',
            b: 'I dont know!',
            c: 'DY Patil Railway Station',
            d: 'Veer Savarkar Railway Station'
        },
        correctAnswer: 'a'
    }]

    get allAreNotSelected()
    {
        return !(Object.keys(this.selected).length === this.myQuestion.length)
      
    }

    changeHandler(event)
    {
        const{name, value}=event.target;
        this.selected={...this.selected,[name]:value};
    }

    submitHandler(event){
        event.preventDefault()//on submit form auto refreshes so to stop auto refresh we use event.preventDefault
        let correct= this.myQuestion.filter(item=>this.selected[item.id] === item.correctAnswer)
        this.correctAnswers = correct.length
        this.isSubmit= true
        console.log('Length of correct answers',this.correctAnswers)

    }

    resetHandler(){
        this.selected ={}
        this.correctAnswers =0;
        this.isSubmit= false

    }
}