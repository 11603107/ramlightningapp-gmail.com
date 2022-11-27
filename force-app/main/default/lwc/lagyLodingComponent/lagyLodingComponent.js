import { LightningElement, wire,track } from 'lwc';
import getAccountList from '@salesforce/apex/LazyLodingController.getAccountList';
export default class LagyLodingComponent extends LightningElement {
firstnum = 20;
@track items = [];
@track items1 = [];
@track todalRecord = [];

connectedCallback() {
    try {
    getAccountList()
    .then(result => {
    this.todalRecord = result;
    for( let i = 0; i< 20; i++){
        this.items.push(result[i]);
        }
        this.items1 = this.items;
})
    .catch(error => {
        this.error = error;
    });
    } catch (error) {
    console.log('err',error); 
    }
    }


handleScroll(event) {
    
    let area = this.template.querySelector('.scrollArea');
    let threshold = 2 * event.target.clientHeight;
let areaHeight = area.clientHeight;
    let scrollTop = event.target.scrollTop;
        if(areaHeight - threshold < scrollTop) {
let total = areaHeight - threshold < scrollTop;
        var lastnum  = this.firstnum + 20;
        for( let i = this.firstnum; i< lastnum; i++){
            this.items.push(this.todalRecord[i]);
                }
            this.items1 = this.items;
            this.firstnum = lastnum;

    }
}
}