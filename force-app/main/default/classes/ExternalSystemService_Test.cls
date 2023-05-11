@IsTest
public with sharing class ExternalSystemService_Test {

    @isTest
    public static void testRegisterAttendeesCallout(){

        List<Account> accs = TestDataFactory.createSObjectList('Account',new Map<String,Object> {
            'Name' => 'Salesforce'
        },3);

        List<Contact> attendeesList1 = TestDataFactory.createSObjectList('Contact',new Map<String,Object>{
            'LastName' => 'Test',
            'Email'   => 'test1@gmail.com',
            'Account' => accs[0]
        },2);

        List<Contact> attendeesList2 = TestDataFactory.createSObjectList('Contact',new Map<String,Object>{
            'LastName' => 'Test',
            'Email'   => 'test2@gmail.com',
            'Account' => accs[1]
        },2);

        List<Contact> attendeesList3 = TestDataFactory.createSObjectList('Contact',new Map<String,Object>{
            'LastName' => 'Test',
            'Email'   => 'test3@gmail.com',
            'Account' => accs[2]
        },3);

        Map<Id, Account> accsMap = new Map<Id, Account>(accs);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExternalServiceCalloutMock(200,'Complete','[{"Name": "Test1"}]'));
        ExternalSystemService.registerAttendees(accsMap.keySet());            
        Test.stopTest();

        System.assertEquals(1, Limits.getFutureCalls());
    }

    @isTest
    public static void testRegisterAttendeesCalloutKO(){

        List<Account> accs = TestDataFactory.createSObjectList('Account',new Map<String,Object> {
            'Name' => 'Salesforce'
        },3);

        List<Contact> attendeesList1 = TestDataFactory.createSObjectList('Contact',new Map<String,Object>{
            'LastName' => 'Test',
            'Account' => accs[0]
        },2);

        List<Contact> attendeesList2 = TestDataFactory.createSObjectList('Contact',new Map<String,Object>{
            'LastName' => 'Test',
            'Account' => accs[1]
        },2);

        List<Contact> attendeesList3 = TestDataFactory.createSObjectList('Contact',new Map<String,Object>{
            'LastName' => 'Test',
            'Account' => accs[2]
        },3);

        Map<Id, Account> accsMap = new Map<Id, Account>(accs);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExternalServiceCalloutMock(201,'Failed',''));
        ExternalSystemService.registerAttendees(accsMap.keySet());            
        Test.stopTest();

        System.assertEquals(1, Limits.getFutureCalls());
    }

    @IsTest
    public static void testNotifyAttendeeByEmail(){

        Account acc = (Account)TestDataFactory.createSObject('Account',new Map<String,Object> {'Name' => 'Salesforce'},true);

        List<Contact> attendeesList = TestDataFactory.createSObjectList('Contact',new Map<String,Object>{
            'LastName' => 'Test',
            'Email' => 'email@gmail.com',
            'Account' => acc
        },10);
        
        Test.startTest();
        ExternalSystemService.notifyAttendeeByEmail(attendeesList);            
        Test.stopTest();

        System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');
    }

}