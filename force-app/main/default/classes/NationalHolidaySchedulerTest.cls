@isTest
private class NationalHolidaySchedulerTest {

    @isTest
    public static void shouldSchedule() {
        String body = '[{"date":"2022-01-01","name":"Confraternização mundial","type":"national"}]';
        HttpMockFactory mock = new HttpMockFactory(
                                                    200, 
                                                    'OK', 
                                                    body, 
                                                    getHeaders());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();

        NationalHolidayScheduler schedule = new NationalHolidayScheduler();
        String sch = '0 0 0 1 1 ?';
        
        List<National_Holidays__c> nationalHolidayList = [SELECT Id FROM National_Holidays__c];

        System.assertEquals(0, nationalHolidayList.size(), 'expected to get 0');
        String jobID = System.schedule('NationalHolidayScheduler', sch, schedule);
        Test.stopTest();

        nationalHolidayList = [SELECT Id FROM National_Holidays__c];
        System.assertEquals(0, nationalHolidayList.size(), 'expected to get 0');

        CronTrigger ct = [SELECT CronExpression FROM CronTrigger WHERE Id = :jobID];
        System.assertEquals(sch, ct.CronExpression);
    }

    @isTest
    public static Map<String, String> getHeaders(){
        return new Map<String, String>{'Content-Type' => 'application/json'};
    }
}
