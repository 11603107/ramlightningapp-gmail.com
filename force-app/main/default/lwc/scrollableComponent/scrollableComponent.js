import { LightningElement, api, track } from 'lwc';
import getIODetails from '@salesforce/apex/ScrollableController.getIODetails';
export default class ScrollableComponent extends LightningElement {
    @api recordId;
    ioStageNames = [];
    @track currentStage;
    @track opportunityList =[];
    currentOpportunityRecord;
    @track lineWidth='0%';
    constructor(){
         super()
        console.log('inside in constructor');
        
    }
    connectedCallback() {
        try {
             console.log('inside in connectedCallback');
            console.log('record Id :: ' + this.recordId);
            console.log('inside in connected call back ');
            getIODetails({ recordId: this.recordId }).then(res => {
                console.log('stage Name - > ' + res.ioStageNames);
                console.log('record --> ' + res.opportunityRecord);
                this.ioStageNames = res.ioStageNames;
                this.currentOpportunityRecord = res.opportunityRecord;
                this.currentStage = res.opportunityRecord.StageName; 
               
                console.log('stage name -- > ' + this.currentStage);
                this.setValues(this.currentStage);
            }).catch(error => {
                this.error = error;
            });

        } catch (error) {
            console.log('error -> ' + error);
        }
    }

    setValues(currentStage) {
        try {
            console.log('inside in save values '+currentStage);
            let currentIndex =0;
            for(var i=0;i<this.ioStageNames.length;i++){
                console.log('this.ioStageNames[i] '+ JSON.stringify(this.ioStageNames[i])+ '-> '+JSON.stringify(currentStage));
                if(currentStage != this.ioStageNames[i]){
                   currentIndex++;
                }else{
                    break;
                }
            }
             console.log('index--> '+currentIndex);
            this.setStageList(currentStage,currentIndex);
            this.lineWidth = (100/(this.ioStageNames.length)+1)*(currentIndex)+'%';
            
        } catch (error) {
            console.log('error --> ' + error);
        }
    }

    get lineWidthh() {
        return `width:${this.lineWidth}`;
    }

    setStageList(currentStage,currentIndex){
        try{
            this.opportunityList =[];
              for(var i=0;i<this.ioStageNames.length;i++)
              {
                  let stageobj={};
                  if(i<=currentIndex)
                  {
                         stageobj={
                            stage : this.ioStageNames[i],
                            isCheck :true,
                            }
                  }else{
                         stageobj={
                            stage : this.ioStageNames[i],
                            isCheck :false,
                            } 
                  } 
                    this.opportunityList.push(stageobj);
              }
              console.log('data --> '+this.opportunityList);
            

        }catch(error){
            console.log('error -> '+error);
        }
    }

    handleStepBlur(event) {
        try {
            console.log('pre stage --> '  )
            console.log('current satage -> ');
            let stageName = event.target.value;
             this.setValues(stageName);

        } catch (error) {
            console.log('error --> ' + error);
        }
    }
/*
    handleStageClick(event) {
        let clickedStageName = event.currentTarget.dataset.stage;
        console.log(`clickedStageName::` + clickedStageName);
        let index = parseInt(event.currentTarget.dataset.index);
        this.handleStageClickk(clickedStageName, index);
    }
    handleStageClickk(clickedStageName, index) {

        console.log(`index::` + index);
        [...this.template.querySelectorAll(`.slds-progress__item`)].forEach(item => {
            console.log(`index 57::` + item.dataset.index);
            let icon = this.template.querySelector(`.approval_icon[data-index="${item.dataset.index}"]`);
            if (parseInt(item.dataset.index) <= index) {
                console.log(`inside first if` + item.className.toString());
                if (!item.className.includes('slds-is-completed')) {
                    item.classList.add('slds-is-completed');
                    console.log(`icon first if icon:::===>` + icon.className.toString());
                    if (icon.className.includes('approveIcon')) {
                        icon.classList.remove('approveIcon');
                    }
                }
            } else {
                console.log('inside else');
                if (item.className.includes('slds-is-completed')) {
                    item.classList.remove('slds-is-completed');
                    console.log(`icon first if icon 70:::===>` + icon.className.toString());

                }
                console.log(`icon first if icon 74:::===>` + icon.className.toString());
                if (!icon.className.includes('approveIcon')) {
                    icon.classList.add('approveIcon');
                }
            }
            console.log(`icon first 75` + icon.className.toString());
        })
    }
 */
}