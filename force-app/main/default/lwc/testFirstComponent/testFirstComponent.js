import { LightningElement } from 'lwc';
export default class TestFirstComponent extends LightningElement {

 drag(event){
    try{
 console.log('inside in drag');
        event.dataTransfer.setData("divId", event.target.id);

        console.log('inside in drag '+event.target.id);
    }catch(err){
        console.log('error in drag -> '+err)
    }
    }
    allowDrop(event){
        console.log('inside in allowDrop');
        event.preventDefault();
    }
    drop(event){
       try{
 console.log('inside in drop');
        event.preventDefault();
        var divId = event.dataTransfer.getData("divId");
         console.log('inside in divId '+divId);
        var draggedElement = this.template.querySelector('divId');
         console.log('inside in drop 111'+draggedElement);
        
               console.log('inside in if ');
              draggedElement.classList.add('completedDragAndDrop'); 
         console.log('inside in drop');
        event.target.appendChild(draggedElement);
         console.log('inside in drop');

        
       
       }catch(error){
           console.log('error -> '+error);
       }
    }

}