import { LightningElement, api, track, wire } from 'lwc';
import getTimeSheetData from '@salesforce/apex/TimeSheetController.getTimeSheetData';
import insertTimeSheetLine from '@salesforce/apex/TimeSheetController.insertTimeSheetLine';
import { NavigationMixin } from 'lightning/navigation';
export default class TimeSheetComponent extends LightningElement {
    startdate;
    endDate;
    currentDate;
    currentColender = [];
    timeSheetdata;
calendarList = [];
isModalOpen = false;
projectName;
billingHours;
projectDescription

connectedCallback() {
    try { 
        
    var curr = new Date;
    console.log('curr--> ' + curr.getDate());
    var first = curr.getDate() - curr.getDay();
    console.log('current date --> '+first);
    var last = first + 6;
    var firstday = new Date(curr.setDate(first)).toUTCString();
    var lastday = new Date(curr.setDate(last)).toUTCString();

    let firstdateObj = new Date(firstday);
    let lastdateObj = new Date(lastday);
    var firstDate = firstdateObj.toDateString();
    var lastDate = lastdateObj.toDateString();
    var calendarfirstDate = firstDate;
    this.startdate = firstDate;
    this.endDate = lastDate;
    let currentDate = new Date().toDateString();
    this.currentDate = currentDate;

    console.log('date type --> '+typeof currentDate);
    var days = ['Sun', 'MON', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    this.calendarList.push({
        day:days[0],
        date:calendarfirstDate.split(' ')[2],
        currentdate:calendarfirstDate,
    });

    var calenderMap = new Map(); 

    for (var i = 1; i <= 6; i++) {

        var currentDate1 = new Date(calendarfirstDate);
        currentDate1.setDate(currentDate1.getDate() + 1);
        let firstDate1 = new Date(currentDate1);
        calendarfirstDate = firstDate1.toDateString();

        this.calendarList.push({
        day:days[i],
                date:calendarfirstDate.split(' ')[2],
            currentdate:calendarfirstDate,
    });
    this.fatchdata();
        
    }
    
    } catch (err) {
        console.log('error--> ' + err);
    }


}
  handleActive(event){
        console.log('inside in chnagedate'+ this.CurrentColender);
        console.log('current date --> '+event.target.value);
        var currentdate = event.target.value;
        this.currentDate = currentdate;
        this.fatchdata();

    }  

    AddRecords(Event){
        
        this.isModalOpen = true;
    
    }

    closeModal(event){
        this.isModalOpen = false;
    }
    fatchdata(){
        console.log('inside in fatch record function '+this.currentDate);
        var currentdate =  this.currentDate;
            getTimeSheetData({"currentDate":currentdate})
            .then(result => {
                this.CurrentColender = result;
                console.log('data --> '+JSON.stringify(result));
            })
            .catch(error => {
                this.error = error;
            });
    }

    submitDetails(event){ 
        try{

                let name = this.template.querySelector('lightning-input[data-name="name"]');
        console.log('Name --> '+name.value);
        let desc = this.template.querySelector('lightning-input[data-desc="desc"]');
        console.log('desc --> '+desc.value);
        let time = this.template.querySelector('lightning-input[data-time="time"]');
        console.log('time --> '+time.value);

        let obj ={
            billable_hours__c:time.value,
            Project_Name__c : name.value,
            Created_Date__c : this.currentDate,
            decription__c : desc.value
        };

        insertTimeSheetLine({timeSheetObj : obj}).then(result => {
                    console.log('return--> '+result);
                    this.closeModal();
            })
            .catch(error => {
                this.error = error;
            });
        


        }catch(err){
            console.log('error--> '+err);
        }

        //console.log('name --> '+this.projectName+'  description --'+this.projectDescription+'  billing--> '+this.billingHours+'  date -> '+this.currentDate);
    }


previousdate() {

    var currentDate1 = new Date(this.currentDate);
    console.log('date -->11 ' + currentDate1);
    currentDate1.setDate(currentDate1.getDate() - 1);
    console.log('date --> ' + currentDate1);
    let cureentDate = new Date(currentDate1);
    var currentDate2 = cureentDate.toDateString();
    this.currentDate = currentDate2;
    this.fatchdata();

}

nextdate() {
    console.log('inside in nextdate');
    var currentDate1 = new Date(this.currentDate);
    currentDate1.setDate(currentDate1.getDate() + 1);
    let cureentDate = new Date(currentDate1);
    var currentDate2 = cureentDate.toDateString();
    this.currentDate = currentDate2;
    this.fatchdata();
}


}