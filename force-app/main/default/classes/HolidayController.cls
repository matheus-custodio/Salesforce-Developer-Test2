public with sharing class HolidayController {
    
    @AuraEnabled(cacheable=true)
    public static HolidayController.Response getHolidays() {
        HolidayController.Response response = new HolidayController.Response();

        List<National_Holidays__c> holidayList =  [SELECT Name, Date__c FROM National_Holidays__c WHERE Date__c >= TODAY ORDER BY Date__c ASC LIMIT 1];
        if(!holidayList?.isEmpty()){
            response.holiday = holidayList[0];
            response.isHoliday = System.today().isSameDay(holidayList[0].Date__c);
            response.daysUntil = System.today().daysBetween(holidayList[0].Date__c);
        }
        return response;
    }

    public class Response {
        @AuraEnabled
        public National_Holidays__c holiday;
        @AuraEnabled
        public Boolean isHoliday;
        @AuraEnabled
        public Integer daysUntil;
    }
}