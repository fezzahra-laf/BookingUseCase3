@IsTest
public with sharing class ReservationRequestHandler_Test {

    @IsTest
    public static void testInsert(){

        Account acc = (Account)TestDataFactory.createSObject('Account',new Map<String,Object> {'Name' => 'Salesforce'},true);
        Test.StartTest();
        Case request = (Case)TestDataFactory.createSObject('Case', new Map<String,Object> { 'Origin' => 'Phone', 'Account' => acc},true);
        Test.StopTest();

        Case req = [SELECT Id FROM Case LIMIT 1];
        System.assertEquals(req.Id, request.Id);
    }

    @IsTest
    public static void testUpdate(){

        Account acc = (Account)TestDataFactory.createSObject('Account',new Map<String,Object> {'Name' => 'Salesforce'},true);
        Case request = (Case)TestDataFactory.createSObject('Case', new Map<String,Object> { 'Origin' => 'Phone', 'Account' => acc},true);
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new ExternalServiceCalloutMock(200,'Complete','[{"Name": "Test1"}]'));
        request.Origin = 'Web';
        update request;
        Test.StopTest();

        Case req = [SELECT Id, Origin FROM Case LIMIT 1];
        System.assertEquals(req.Origin, 'Web');
    }
}