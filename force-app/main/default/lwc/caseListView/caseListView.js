import { LightningElement, wire, track } from 'lwc';
import fetchCaseRecords from '@salesforce/apex/CaseListView_controller.fetchCaseRecords';
import fetchCaseRecordBySort from '@salesforce/apex/CaseListView_controller.fetchCaseRecordBySort';


export default class CaseListView extends LightningElement {
    @track listOfCase;
    @track listOfStatus;
     @track allSelect =false; 
     @track StageNameOpoup = false;
 @track colomName = [
	   {key:'CaseNumber', value:'Case Number', checkIcon : false}, 
	   {key:'Account.Name', value:'Account Name', checkIcon : false},
	   {key:'Owner.Name', value:'Owner Name', checkIcon : false},
	   {key:'Status', value:'Status', checkIcon : true},
	   {key:'CreatedDate', value:'CreatedDate', checkIcon : false}] 

    connectedCallback() {
          try { 
              console.log('inside in conncted call back');
            fetchCaseRecords().then(res=> {
                console.log(' --> '+JSON.stringify(res.caseList));
                 this.listOfCase = res.caseList
                this.listOfStatus = res.StageValuesList;
                
              //  console.log('data--> ' + JSON.stringify( this.listOfCase));
                console.log('data--> ' + res.caseList.length);
                 console.log('data--> ' + res.StageValuesList.length);
                //console.log('map--> ' + JSON.stringify(this.weekDaysMap));
                console.log('Testvalue'+this.weekDaysMap.get('Sunday'));
                this.initData();
            }).catch(error => {
                this.error = error;
            });


        } catch (err) {
            console.log('error--> ' + err);
        }
    }

    SelectAllRecords(event){
       try{
           console.log('inside in all select'+this.allSelect);
          

       }catch(error){
           console.log('error -> '+error);
       } 
    }

    soringdata(event){
        try{
            let apiName = event.currentTarget.dataset.id;
            console.log('type-> '+typeof apiName);
            console.log('Id ->  '+apiName);
             fetchCaseRecordBySort({fieldName : apiName}).then(res =>{
                 console.log('data -> '+res);
                 this.listOfCase = res;

             }).catch(error=>{
                 console.log('error ->'+error);
             });  
        }catch(error){
            console.log('error -> '+error);
        }
    }
    openStagePopup(event){
        try{
            this.StageNameOpoup = true;
            

        }catch(eror){
            console.log('error -> '+eror);
        }
    }

}