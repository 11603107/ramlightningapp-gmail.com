import { LightningElement, wire, track } from 'lwc';
import fatchRecords from '@salesforce/apex/TimeSheetApexClass.fatchRecords';
import createtimeSheetrecord from '@salesforce/apex/TimeSheetApexClass.createtimeSheetrecord';
import deleteRowOfTimeSheet from '@salesforce/apex/TimeSheetApexClass.deleteRowOfTimeSheet';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/User.Name';
import Id from '@salesforce/user/Id';
const fields = [NAME_FIELD];
export default class NewTimeSheet extends LightningElement {

    @wire(getRecord, { recordId: Id, fields })
    userName({error,data}){
        if(data){
            
            console.log('data-->',data);
            this.userName = data;
            this.isLoading = true;
            setTimeout(() => {
                console.log('inisde in loding');
                this.doJavascriptOperation();
            }, 2000);
           
        }
        if(error){
            console.log('error  --> ' + error);
        }
    }

    todaysDate
    @track weekList = [];
    project = [];
    task = [];
    userList = [];
    currentuser;
    isLoading = false;
    @track currentuserName;
    @track listofTimeSheet = [];
    @track totalWeeklyHours= [];
    @track totalDayHours= [];
    @track totalHoursOfWeek ;




    connectedCallback() {

       
    }

    doJavascriptOperation() {
        try{
            console.log('use name -- > ' + JSON.stringify(Id) + ' name =--> ' + this.userName.fields.Name.value);
            this.currentuserName = this.userName.fields.Name.value;

            //  this.callApexclass();
            let today = new Date().toISOString().slice(0, 10);
            this.todaysDate = today;
            var myDate = new Date(today);
            myDate.setDate(myDate.getDate());
            console.log('---> ' + myDate);


            // this.initData();
            this.createCalenderList(today);
            this.isLoading = false;
        }catch(error){
            console.log(error);
        }
    };

    /*
            console.log('use name -- > ' + JSON.stringify(Id) + ' name =--> ' + this.userName.data.fields.Name.value);
            this.currentuserName = this.userName.data.fields.Name.value;
    
    
            //  this.callApexclass();
            let today = new Date().toISOString().slice(0, 10);
            this.todaysDate = today;
            var myDate = new Date(today);
            myDate.setDate(myDate.getDate());
            console.log('---> ' + myDate);
    
    
            // this.initData();
            this.createCalenderList(today);
        } */

    callApexclass() {
        try {
            var firstdateofweek = this.currentuserName + ' - ' + this.weekList[0].date;
            fatchRecords({ 'nameOfTiemSheet': firstdateofweek }).then(res => {
                this.project = res.porojectList;
                this.task = res.taskList;
                this.userList = res.userList;
                this.currentuser = res.userobj;
                this.listofTimeSheet = res.timeSheetList;
                this.currentuserName = res.userobj.Name;
                console.log('data--> ' + JSON.stringify(res.porojectList));
                console.log('data--> ' + res.taskList);
                console.log('name--> ' + JSON.stringify(this.currentuser));
                this.initData();
            }).catch(error => {
                this.error = error;
            });


        } catch (err) {
            console.log('error--> ' + err);
        }
    }


    currentDate(event) {
        try {  
            console.log('nside in current date ' + event.target.value + ' type -> ' + typeof event.target.value);

            var curr = new Date(event.target.value);
            console.log('day- > ' + curr.getDay() + ' --> ' + curr.getDate());

            this.createCalenderList(event.target.value);

        } catch (err) {
            console.log('data --> ' + err);
        }
    }

    createCalenderList(currentdate) {
        try {
            this.weekList = [];
            console.log('date--> ' + currentdate);
            var myDate = new Date(currentdate);
            myDate.setDate(myDate.getDate());
            var first = myDate.getDate() - myDate.getDay();
            console.log('first date -> ' + first);

            var last = first + 7;

            console.log('last --> ' + last);
            var datenew;
            var days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            for (var i = 1; i <= 7; i++) {
                let weekdate = {};
                datenew = new Date(myDate.setDate(first + i)).toISOString().slice(0, 10);
                weekdate.date = datenew;
                weekdate.day = days[i - 1];
                this.weekList.push(weekdate);
                console.log('date--> ' + i + '--> ' + datenew.slice(0, 10));
            }
            console.log(' this.weekList --> ' + this.weekList[0].date);
            this.callApexclass();

        } catch (err) {
            console.log('error--> ' + err);
        }
    }
    initData() {
        let listofTimeSheet = this.listofTimeSheet;
        console.log('List of data --> ' + JSON.stringify(listofTimeSheet));
        this.createRow(listofTimeSheet);
        this.listofTimeSheet = listofTimeSheet;
    }

    createRow(listofTimeSheet) {
        try {
            let newtimeSheetList = JSON.parse(JSON.stringify(listofTimeSheet));
            console.log('inside in create record ' + JSON.stringify(this.listofTimeSheet));
            console.log('inside in create record new  ' + JSON.stringify(listofTimeSheet));
            let accountObject = {};
            if (listofTimeSheet.length > 0) {

                accountObject.row__c = listofTimeSheet[listofTimeSheet.length - 1].row__c + 1;
            } else {
                console.log('inside in else');
                accountObject.row__c = 1;
            }
            
            accountObject.ShowProject__c = true;
            accountObject.Billing_Project__c = null;
            accountObject.project_Task__c = null;
            accountObject.mon__c = 0;
            accountObject.Tue__c = 0;
            accountObject.Wed__c = 0;
            accountObject.Thu__c = 0;
            accountObject.Fri__c = 0;
            accountObject.Sat__c = 0;
            accountObject.Sun__c = 0;
            console.log('object -> ' + JSON.stringify(accountObject));
            console.log('List size--> ' + listofTimeSheet.length);

            newtimeSheetList.push(accountObject);
            console.log('after add object in LIst ');
            this.listofTimeSheet = newtimeSheetList;
            console.log('listofTimeSheet-> ' + this.listofTimeSheet.length);

            this.calculateTotalHours(this.listofTimeSheet);

        } catch (err) {
            console.log('error --> ' + err);
        }
    }
    calculateTotalHours(listOfTimeSheet){
        try{
            var monHours = 0;
            var tueHour = 0 ;
            var wedHours = 0; 
            var friHours = 0 ;
            var satHours = 0;
            var sunHours  = 0 ;
            var thuHours = 0;

            var totalHoursProject = JSON.parse(JSON.stringify(this.totalWeeklyHours));
            var  totalWeeklyHoursChnage = [];
            this.totalWeeklyHoursChnage = [];
            for(var i=0;i<listOfTimeSheet.length;i++){
                    var projectHours = parseInt(listOfTimeSheet[i].Wed__c)+ parseInt(listOfTimeSheet[i].Fri__c)+ parseInt(listOfTimeSheet[i].Sat__c)+  parseInt(listOfTimeSheet[i].Sun__c)+  parseInt(listOfTimeSheet[i].Thu__c)+  parseInt(listOfTimeSheet[i].mon__c)+  parseInt(listOfTimeSheet[i].Tue__c);
                    totalHoursProject[i]=projectHours;
                    monHours = parseInt(monHours)+parseInt(listOfTimeSheet[i].mon__c);
                    tueHour = parseInt(tueHour)+parseInt(listOfTimeSheet[i].Tue__c);
                    wedHours = parseInt(wedHours)+parseInt(listOfTimeSheet[i].Wed__c);
                    thuHours = parseInt(thuHours)+parseInt(listOfTimeSheet[i].Thu__c);
                    friHours = parseInt(friHours)+parseInt(listOfTimeSheet[i].Fri__c);
                    satHours = parseInt(satHours)+parseInt(listOfTimeSheet[i].Sat__c);
                    sunHours = parseInt(sunHours)+parseInt(listOfTimeSheet[i].Sun__c);  
            }
            this.totalWeeklyHours = totalHoursProject;
            totalWeeklyHoursChnage[0]= monHours;
            totalWeeklyHoursChnage[1]= tueHour;
            totalWeeklyHoursChnage[2]= wedHours;
            totalWeeklyHoursChnage[3]= thuHours;
            totalWeeklyHoursChnage[4]= friHours;
            totalWeeklyHoursChnage[5]= satHours;
            totalWeeklyHoursChnage[6]= sunHours;
            
            console.log('  this.totalWeeklyHours --> '+  this.totalWeeklyHours);
            console.log('  this.totalWeeklyHoursChnage --> '+  totalWeeklyHoursChnage);
            var totalHoursOfWeek = 0;
            
            for (let i = 0; i < totalWeeklyHoursChnage.length; i++) {
                totalHoursOfWeek += totalWeeklyHoursChnage[i];
            }
            this.totalHoursOfWeek = totalHoursOfWeek
            
            this.totalWeeklyHoursChnage = totalWeeklyHoursChnage;


        }catch(error){
            console.log('error -> '+error);
        }
    }

    removeRow(event) {
        let toBeDeletedRowIndex = event.target.name;
        let listofTimeSheet = [];
        console.log('tobedete--> ' + toBeDeletedRowIndex);
        let deleteTimeSheetList = [];
        let updateTimeSheetList = [];

        for (let i = 0; i < this.listofTimeSheet.length; i++) {

            let tempRecord = Object.assign({}, this.listofTimeSheet[i]);
            //cloning object
            if (tempRecord.row__c !== toBeDeletedRowIndex) {

                console.log('Row -> ' + tempRecord.row__c + ' and --> ' + toBeDeletedRowIndex);
                listofTimeSheet.push(tempRecord);
            } else {
                if (tempRecord.Id != null) {
                    deleteTimeSheetList.push(tempRecord);
                }
                console.log('deleet row'+tempRecord);
                console.log('Row -> ' + tempRecord.row__c + ' and --> ' + toBeDeletedRowIndex);
            }
        }
        console.log('deleet row'+deleteTimeSheetList);
        for (let i = 0; i < listofTimeSheet.length; i++) {
            listofTimeSheet[i].row__c = i + 1;
        }
      
        this.listofTimeSheet = listofTimeSheet;

        for (let i = 0; i < listofTimeSheet.length; i++) {
            console.log('update List '+listofTimeSheet[i]);
        }

          

        if(deleteTimeSheetList.length >0){
            this.listofTimeSheet = listofTimeSheet;
            deleteRowOfTimeSheet({ deleteList: deleteTimeSheetList, updateList: this.listofTimeSheet }).then(res => {
                console.log('return --> ' + res);
            }).catch((error => {
                console.log('error --> ' + error)
            }));

        } 
        this.calculateTotalHours(this.listofTimeSheet);

    }

    addNewRow() {
        console.log('inside in add new row');
        this.createRow(this.listofTimeSheet);
    }

    createAccounts() {
        console.log('inside in edit record ');
    }

    cancel() {
        console.log('inside in cancel function ');
    }
    selectpickListChangeHandler(event) {
        console.log('Id --> ' + event.target.value);
        let toBeDeletedRowIndex = event.target.name;
        console.log('delete --> ' + toBeDeletedRowIndex);

    }

    handleInputChange(event) {
        try {
            var value = event.target.value;
            var name = event.target.name;
            console.log('List ---> ' + JSON.stringify(this.listofTimeSheet));
            let newtimeSheetList = JSON.parse(JSON.stringify(this.listofTimeSheet))
            let index = event.target.dataset.id;
            console.log('value--> ' + value + ' index --> ' + index + ' name--> ' + name);
            console.log('Project Id --> ' + newtimeSheetList[index - 1][event.target.name]);
            newtimeSheetList[index - 1][event.target.name] = value;
                


            // console.log('Project Id --> row ' + this.listofTimeSheet[index - 1].name );
            console.log('data--> ' + JSON.stringify(newtimeSheetList[index - 1]));
            this.listofTimeSheet = newtimeSheetList;
            this.calculateTotalHours(this.listofTimeSheet);  
        } catch (err) {
            console.log('error--> ' + err);
        }
    }

    SaveRecord(event) {
        try {
            let timesheet = {};
            let newtimeSheetList = JSON.parse(JSON.stringify(this.listofTimeSheet))
            console.log('name --> ' + this.currentuserName + ' - ' + this.weekList[0].date);
            timesheet.Name = this.currentuserName + ' - ' + this.weekList[0].date;
            timesheet.Employee__c = this.currentuser.Id;
            timesheet.Start_Date__c = this.weekList[0].date;
            console.log(' tike sheet --> ' + timesheet);
            console.log('data --> ' + JSON.stringify(newtimeSheetList));
            for (var i = 0; i < newtimeSheetList.length; i++) {
                if (newtimeSheetList[i].Billing_Project__c === null) {
                    var x = parseInt(i) + parseInt(1);
                    alert('Please select project on index ' + x);
                    break;
                }
            }
            this.listofTimeSheet = newtimeSheetList;
            console.log('current uswr---> '+JSON.stringify(this.listofTimeSheet));

            createtimeSheetrecord({ timeSheetObject: timesheet, listOfNewTimeSheet: this.listofTimeSheet }).then(res => {
               console.log('res.timeSheet --> '+res.timeSheet+ ' --> '+(res.timeSheet === true)+' --> '+((res.timeSheet === true) && (res.timeSheetEntry === true)));
               console.log('res.timeSheetEntry --> '+res.timeSheetEntry+ ' --> '+(res.timeSheetEntry === true)+' -> '+((res.timeSheet === true) && (res.timeSheetEntry === true)));

                if((res.timeSheet === true) && (res.timeSheetEntry === true)){
                    
                        console.log('inside in true');
                    const evt = new ShowToastEvent({
                        title: 'Success',
                        message: 'This is a success message',
                        variant: 'success',
                    });
                    console.log('eror-> ');
                    this.dispatchEvent(evt);
                    // this.isLoading = true;s
                   this.setTimeout();
                    // this.doJavascriptOperation();

                    

                }else{
                    console.log('inside in false');
                    const evt = new ShowToastEvent({
                        title: 'Error',
                        message: 'Records not saved',
                        variant: error,
                    });
                    this.dispatchEvent(evt);
                }

            }).catch(error => {
                this.error = error;
            });

        } catch (err) {
            console.log('error--> ' + err);
        } 
    }

    cancelRecord(event){
       try{
        console.log('inside in calcel button ');
        this.doJavascriptOperation();

       }catch(error){
           console.log('inside in error '+error);
       }
    }

    changeProjectList(event){
        try{
            console.log('insde in onchage 00');
            var name =event.target.name;
            console.log('name -> '+name);
        }catch(error){
            console.log('inside in onchange error '+error);
        }
    }

}