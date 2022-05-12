public with sharing class NationalHolidayService {

    @future (callout=true) //Changed into single method because of Scheduler and Exception Test
    public static void getHolidays(String year) {
        List<HolidayVO> holidaysList = doCallout(year);
        if(!holidaysList?.isEmpty()){
            insertRecords(holidaysList);
        }
    }

    public static List<HolidayVO> doCallout(String year) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:NationalHolidayEndpoint/' + year);
        request.setMethod('GET');

        HttpResponse response = http.send(request);
        if(response.getStatusCode() != 200){
            throw new NationalHolidayServiceException('Error on request, Code:' + response.getStatusCode() + ', Body:' + response.getBody());
        }

        String body = (response.getBody()).replace('date', 'holidayDate');
        List<HolidayVO> holidaysList = (List<HolidayVO>) JSON.deserialize(body, List<HolidayVO>.class);

        return holidaysList;
    }

    public static void insertRecords(List<HolidayVO> holidaysList) {
        List<National_Holidays__c> nationalHolidayList = new List<National_Holidays__c>();

        for (HolidayVO holiday : holidaysList) {
            nationalHolidayList.add(
                new National_Holidays__c(
                    Date__c = Date.valueOf(holiday.holidayDate),
                    Type__c = holiday.type,
                    Name = holiday.name
                )
            );
        }

        if(nationalHolidayList?.isEmpty()) {
            return;
        }

        try {
            insert nationalHolidayList;
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    public class NationalHolidayServiceException extends Exception {}
}