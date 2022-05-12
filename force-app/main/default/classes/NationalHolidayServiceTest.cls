@isTest
private class NationalHolidayServiceTest {

    @isTest
    public static void shouldDoCallout() {
        String body = '[{"date":"2022-01-01","name":"Confraternização mundial","type":"national"}]';
        HttpMockFactory mock = new HttpMockFactory(
                                                    200, 
                                                    'OK', 
                                                    body, 
                                                    getHeaders());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();

        NationalHolidayService.getHolidays('2022');
        List<National_Holidays__c> nationalHolidayList = [SELECT Id FROM National_Holidays__c];
        System.assertEquals(0, nationalHolidayList.size(), 'expected to get 0');
        Test.stopTest();
        nationalHolidayList = [SELECT Id FROM National_Holidays__c];
        System.assertEquals(1, nationalHolidayList.size(), 'expected to get 1');
    }

    @isTest
    private static void shouldInsertHolidays() {
        String body = '[{"date":"2022-01-01","name":"Confraternização mundial","type":"national"}]';
        HttpMockFactory mock = new HttpMockFactory(
                                                    200, 
                                                    'OK', 
                                                    body, 
                                                    getHeaders());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();

        NationalHolidayService.getHolidays('2022');
        
        Test.stopTest();
        List<National_Holidays__c> nationalHolidayList = [SELECT Id FROM National_Holidays__c];
        System.assertEquals(1, nationalHolidayList.size(), 'expected to get 1');
    }

    @isTest
    private static void shouldGetError() {
        String body = '{"message":"Ano fora do intervalo suportado entre 1900 e 2199.","type":"feriados_range_error","name":"NotFoundError"}';
        HttpMockFactory mock = new HttpMockFactory(
                                                    404, 
                                                    'Not Found', 
                                                    body, 
                                                    getHeaders());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        
        try {
            List<HolidayVO> holidaysList = NationalHolidayService.doCallout('9999');
            NationalHolidayService.insertRecords(holidaysList);
        } catch (Exception e) {
            System.assertEquals('NationalHolidayService.NationalHolidayServiceException', e.getTypeName(), 'expected to get NationalHolidayServiceException');
            System.assert(e.getMessage().contains('NotFoundError'));
        }

        Test.stopTest();
        List<National_Holidays__c> nationalHolidayList = [SELECT Id FROM National_Holidays__c];
        System.assertEquals(0, nationalHolidayList.size(), 'expected to get 0');
    }

    @isTest
    public static void shouldGetInternalError() {
        String body = '{"message":"Erro ao calcular feriados.","type":"feriados_error","name":"InternalError"}';
        HttpMockFactory mock = new HttpMockFactory(
                                                    500, 
                                                    'Internal Error Server', 
                                                    body, 
                                                    getHeaders());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();

        try {
            List<HolidayVO> holidaysList = NationalHolidayService.doCallout('aaa');
            NationalHolidayService.insertRecords(holidaysList);
        } catch (Exception e) {
            System.assertEquals('NationalHolidayService.NationalHolidayServiceException', e.getTypeName(), 'expected to get NationalHolidayServiceException');
            System.assert(e.getMessage().contains('InternalError'));
        }
        List<National_Holidays__c> nationalHolidayList = [SELECT Id FROM National_Holidays__c];

        Test.stopTest();
        System.assertEquals(0, nationalHolidayList.size(), 'expected to get 0');
    }

    @isTest
    public static void shouldReturn() {
        String body = '[]';
        HttpMockFactory mock = new HttpMockFactory(
                                                    200, 
                                                    'OK', 
                                                    body, 
                                                    getHeaders());
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();

        NationalHolidayService.getHolidays('2022');
        List<National_Holidays__c> nationalHolidayList = [SELECT Id FROM National_Holidays__c];

        Test.stopTest();
        System.assertEquals(0, nationalHolidayList.size(), 'expected to get 0');
    }

    @isTest
    public static Map<String, String> getHeaders(){
        return new Map<String, String>{'Content-Type' => 'application/json'};
    }
}