@isTest
private class HolidayControllerTest {
    @TestSetup
    static void makeData(){
        National_Holidays__c nhTest = new National_Holidays__c(
                                            Date__c = System.today(),
                                            Type__c = 'national',
                                            Name = 'test'
                                        );
        insert nhTest;
    }
    @isTest
    private static void shouldGetHolidays(){
        Test.startTest();
        HolidayController.Response response = HolidayController.getHolidays();
        Test.stopTest();
        System.assertEquals(System.today(), response.holiday.Date__c);
        System.assertEquals(true, response.isHoliday);
        System.assertEquals(0, response.daysUntil);
    }
}
