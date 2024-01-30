import { LightningElement } from 'lwc';
export default class DogApi extends LightningElement 
{
    imageReady = false;
    loadingSpinner = false;
    pictureUrl;
    handleClick(){
        try{
            this.loadingSpinner = true;
        this.imageReady = false;
        fetch('https://dog.ceo/api/breeds/image/random', {method: "GET" , mode: 'no-cors'
        })
            .then(response => response.json())
            console.log(response)
            .then(data => {
                this.pictureUrl = data.message;
                this.imageReady = true;
                this.loadingSpinner = false;
            });

        }
        catch(response)
        {
            console.log(response.message);
        }
        
    }
}