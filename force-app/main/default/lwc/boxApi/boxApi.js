/* create by Ram Niwas Verma
 // USe for Box Api intregration 
    Date 11/07/22
 */


import { LightningElement , api} from 'lwc';
import getallFiles from '@salesforce/apex/GetAccessTokenOfBoxApi.getallFiles'; 
 
export default class BoxApi extends LightningElement {
    entriesList = [];
    @api accesstoken;
    @api Id =0;
    connectedCallback(){
        try{
            let entries  ;
            console.log('inside in connected call back');
            getallFiles({folderId :this.Id}).then(res =>{
              try{
              //  console.log('inside in total_count '+JSON.stringify(res.total_count));
                console.log('inside in entries '+JSON.stringify(res.entries));
                 entries = res.entries;
                console.log('inside in offset111 '+JSON.stringify(res.offset)); 
                console.log('data -> '+  entries); 
                 entries.forEach(dataentry =>{
                    console.log('name -> '+dataentry.name);
                    console.log('file -> '+dataentry.type);
                    let icon = 'standard:'+dataentry.type;
                    dataentry.icon = icon;
                    dataentry.ParentfolderId  = this.Id;
                    dataentry.sunArray =[];
                });
                this.entriesList = entries;
              }catch(error){
                console.log('error -> '+error);
              }  
            }).catch(error =>{
                console.log('error-> '+error);
            });
            console.log('after apex controller  '); 
            
        }catch(error){
            console.log('error -> '+error);
        }
    }

    getFolderRecords(event){
        try{
            let Id =event.currentTarget.dataset.id;
            console.log('Id -> '+Id);
            getallFiles({folderId :Id}).then(res =>{
                try{
                //  console.log('inside in total_count '+JSON.stringify(res.total_count));
                  console.log('inside in entries '+JSON.stringify(res.entries));
                  this.entries = res.entries;
                  console.log('inside in offset111 '+JSON.stringify(res.offset)); 
                  console.log('data -> '+ this.entries); 
                  this.entries.forEach(dataentry =>{ 
                      let icon = 'standard:'+dataentry.type;
                      dataentry.icon = icon; 
                  });
                }catch(error){
                  console.log('error -> '+error);
                }  
              }).catch(error =>{
                  console.log('error-> '+error);
              });

        }catch(error){
            console.log('error--> '+error);
        }
    }
    
}