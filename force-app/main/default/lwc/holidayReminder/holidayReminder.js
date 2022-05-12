import { LightningElement, wire } from 'lwc';

import getHolidays from '@salesforce/apex/HolidayController.getHolidays';

export default class Holiday extends LightningElement {
    holiday;
    isHoliday;
    daysUntil;
    @wire(getHolidays) response({error, data}){
        error && console.log(error);
        if(data){
            this.holiday = data.holiday;
            this.isHoliday = data.isHoliday;
            this.daysUntil = data.daysUntil;
        }
    };

}