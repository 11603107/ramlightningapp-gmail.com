import { LightningElement } from 'lwc';
import fetchDate from '@salesforce/apex/TimeSheetnewComponentController.fetchDate';
import insertTimeSheetLine from '@salesforce/apex/TimeSheetnewComponentController.insertTimeSheetLine';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { deleteRecord } from 'lightning/uiRecordApi';

import { NavigationMixin } from 'lightning/navigation';


export default class TimeSheetnewComponent extends NavigationMixin(LightningElement) {
    startdate;
    isDeleteRecord =  false;
    endDate;
    currentDate;
    currentColender = [];
    timeSheetdata = [];
    calendarData = [];
    calendarList = [];
    isModalOpen = false;
    isLoading = false;
    todaysDate ;
    showcurrentdate = false;

    connectedCallback() {
        try {
          
            var curr = new Date;
            console.log('curr--> ' + curr.getDate()+ 'curr --> '+ JSON.stringify(curr) );
              var currdate = new Date(curr.setDate(curr.getDate())).toUTCString();
                let currdate1 = new Date(currdate);
                 var todaysDate = currdate1.toDateString();
                 this.todaysDate = todaysDate;
        console.log(' this.todaysDate --> '+ this.todaysDate);
            var first = curr.getDate() - curr.getDay();
            this.nextWeek(first);
        } catch (err) {
            console.log('error--> ' + err);
        }
    }

    preweek(first) {
        console.log('inside in pre week ');
        var curr = new Date;
        var last = first - 7;
        this.fetchDateofWeek(last, first, 'pre');
        var firstday = new Date(curr.setDate(first - 1)).toUTCString();
        var lastday = new Date(curr.setDate(last)).toUTCString();
        console.log('first and last --> ' + firstday + ' --> ' + lastday);

        let firstdateObj = new Date(firstday);
        let lastdateObj = new Date(lastday);
        var firstDate = firstdateObj.toDateString();
        var lastDate = lastdateObj.toDateString();
        var calendarfirstDate = firstDate;
        this.endDate = firstDate;
        this.startdate = lastDate;
        console.log('endDate--> ' + firstDate + ' startdate--> ' + lastDate);
        let currentDate = firstDate;
        this.currentDate = currentDate;
        this.todaysDate = currentDate;
      

    }

    handleActive(event) {
       
        console.log('inside in chnagedate' + this.CurrentColender);
        console.log('current date --> ' + event.target.value);
          console.log('lable date --> ' + event.target.label);
        
        var currentdate = event.target.value;
        this.currentDate = currentdate;
        this.todaysDate = currentdate;
        this.storedata(this.currentDate);

    }

    nextWeek(first) {
        console.log('inside in next week ');
        var curr = new Date;
        var last = first + 7;
        this.fetchDateofWeek(first, last, 'next');
        console.log('last --> ' + last);
        var firstday = new Date(curr.setDate(first + 1)).toUTCString();
        var lastday = new Date(curr.setDate(last)).toUTCString();
        console.log('first and last --> ' + firstday + ' --> ' + lastday);

        let firstdateObj = new Date(firstday);
        let lastdateObj = new Date(lastday);
        var firstDate = firstdateObj.toDateString();
        var lastDate = lastdateObj.toDateString();
        var calendarfirstDate = firstDate;
        this.startdate = firstDate;
        this.endDate = lastDate;
        console.log('firstDate -> ' + firstDate);
        console.log('lastDate -> ' + lastDate);


        let currentDate = firstDate;
        this.currentDate = currentDate;
        this.storedata(currentDate);

    }
    fetchDateofWeek(firstDate, lastDate, action) {
        try {
            this.calendarList = [];
            var dateList = [];
            var first = firstDate;
            var last = lastDate;
            var curr = new Date;

            if (action == 'next') {
                console.log('insode in next - > ' + firstDate);
                for (var i = 1; i <= 7; i++) {
                    var firstday = new Date(curr.setDate(first + i)).toUTCString();
                    let firstdateObj = new Date(firstday);
                    var firstDate = firstdateObj.toDateString();
                    dateList.push(firstDate);
                    this.calendarList.push({
                        day: firstDate.split(' ')[0],
                        date: firstDate.split(' ')[2],
                        currentdate: firstDate,
                    });

                }

            } else {
                console.log('inside in pre--> ' + firstDate);
                for (var i = 0; i <= 6; i++) {
                    var firstday = new Date(curr.setDate(first + i)).toUTCString();
                    console.log('inside in pre --> ' + firstday);
                    let firstdateObj = new Date(firstday);
                    var firstDate = firstdateObj.toDateString();
                    console.log('firstDate --> ' + i + '==> ' + firstDate)
                    dateList.push(firstDate);
                    this.calendarList.push({
                        day: firstDate.split(' ')[0],
                        date: firstDate.split(' ')[2],
                        currentdate: firstDate,
                    });

                }
            }


        } catch (err) {
            console.log('err--> ' + err);
        }
    }
    storedata(currentdate) {
        try {
            var currentdate = currentdate;
            this.timeSheetdata = [];
            fetchDate({ 'currentdate': currentdate })
                .then(result => {
                    console.log('data --> ' + JSON.stringify(result));
                    console.log('type--> ' + typeof result[0].billable_hours__c);
                    this.timeSheetdata = result;


                }).catch(error => {
                    this.error = error;
                });


        } catch (err) {
            console.log('roor--> ' + err);
        }
    }

    previousdate() {
        try {
          
             this.todaysDate =null;
            console.log('inside in pre');
            const day = this.currentDate.split(' ')[0];
            console.log('day--> ' + day);
            if (day == 'Mon') {
                var curr = new Date(this.currentDate);
                this.preweek(curr.getDate());
            } else {
               
                var currentDate1 = new Date(this.currentDate);
                console.log('date -->11 ' + currentDate1);
                currentDate1.setDate(currentDate1.getDate() - 1);
                console.log('date --> ' + currentDate1);
                let cureentDate = new Date(currentDate1);
                var currentDate2 = cureentDate.toDateString();
                this.currentDate = currentDate2;
                this.todaysDate = currentDate2;
                console.log('date--> ' + this.currentDate);
                this.storedata(this.currentDate);
            }

        } catch (err) {
            console.log('error--> ' + err);
        }
    }

    nextdate() {
        try {
            
             this.todaysDate =null;
            const day = this.currentDate.split(' ')[0];
            if (day == 'Sun') {
                var curr = new Date(this.currentDate);
                this.nextWeek(curr.getDate());
            } else {
                var currentDate1 = new Date(this.currentDate);
                currentDate1.setDate(currentDate1.getDate() + 1);
                let cureentDate = new Date(currentDate1);
                var currentDate2 = cureentDate.toDateString();
                this.currentDate = currentDate2;
                this.todaysDate = currentDate2;
                console.log('date--> ' + this.currentDate);
                this.storedata(this.currentDate);

            }
        } catch (err) {
            console.log('error--> ' + err);
        }
    }

    AddRecords(Event) {
         const currentdate = this.currentDate;
         
            console.log('currentdate-->11 ' + currentdate); 

           /* const addRecordevent = new CustomEvent("addRecord", {
                detail: { currentdate }
            });
            // Fire the custom event
            this.dispatchEvent(addRecordevent);
*/

       this.isModalOpen = true;

    }

    closeModal(event) {
        this.isModalOpen = false;
        this.isDeleteRecord = false;
    }

    submitDetails(event) {
        try {

            let name = this.template.querySelector('lightning-input[data-name="name"]');
            console.log('Name --> ' + name.value);
            let desc = this.template.querySelector('lightning-input[data-desc="desc"]');
            console.log('desc --> ' + desc.value);
            let time = this.template.querySelector('lightning-input[data-time="time"]');
            console.log('time --> ' + time.value);

            let obj = {
                billable_hours__c: time.value,
                Project_Name__c: name.value,
                Created_Date__c: this.currentDate,
                decription__c: desc.value
            };

            insertTimeSheetLine({ timeSheetObj: obj }).then(result => {
                console.log('return--> ' + result);
                if (result === true) {
                    this.isLoading = true;
                    const evt = new ShowToastEvent({
                        title: 'Toast Success',
                        message: 'Opearion sucessful',
                        variant: 'success',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);

                } else {
                    const evt = new ShowToastEvent({
                        title: 'Toast Error',
                        message: 'Some unexpected error',
                        variant: 'error',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);

                }
                this.closeModal();

                this.storedata(this.currentDate);
            })
                .catch(error => {
                    this.error = error;
                });



        } catch (err) {
            console.log('error--> ' + err);
        }

        //console.log('name --> '+this.projectName+'  description --'+this.projectDescription+'  billing--> '+this.billingHours+'  date -> '+this.currentDate);
    }

    startTime(event) {
        try {
            const recordId = event.target.value;
            console.log('id-->11 ' + recordId);
 
            const editRecordevent = new CustomEvent("valuechange", {
                detail: { recordId }
            });
            // Fire the custom event
            this.dispatchEvent(editRecordevent); 

        } catch (err) {
            console.log('werror--> ' + err);
        }
    }
    finalDeleteRecord(event){
        try{ 
             
         deleteRecord(this.currentRecordDelete)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted',
                        variant: 'success'
                    })
                );
                // Navigate to a record home page after
                // the record is deleted, such as to the
                // contact home page
                
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
            this.closeModal();

        }catch(err){
            console.log('error--> '+err);
        }

    }

    deletecurrRecord(event){
      try{
            this.currentRecordDelete = event.target.value;
            this.isDeleteRecord = true;


      }catch(err){
          console.log('error--> '+err);
      }
    }
}