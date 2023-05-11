@IsTest
public with sharing class ReservationRequestHelper_Test {
    
    @isTest
    public static void refuseCaseCreationWhenAnAccountIsNotAttachedToACase(){
        
        Case request = (Case)TestDataFactory.createSObject('Case', new Map<String,Object> {'Origin' => 'Phone' },false);

        Test.startTest();
        Database.SaveResult result = Database.insert(request, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals(Label.ReservationWithoutAccount, result.getErrors()[0].getMessage());
    }
    
    @isTest
    public static void refuseCaseCreationWhenNoContactIsAttachedToAnAccount(){

        Account acc = (Account)TestDataFactory.createSObject('Account',new Map<String,Object> {'Name' => 'accountNoContacts'},true);
        Case request = (Case)TestDataFactory.createSObject('Case', new Map<String,Object> { 'Origin' => 'Phone', 'Account' => acc},false);

        Test.startTest();
        Database.SaveResult result = Database.insert(request, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals(Label.NoContactInfo, result.getErrors()[0].getMessage());
    }
    
    @isTest
    public static void bookEventFromPhone(){
        
        Account acc = (Account)TestDataFactory.createSObject('Account',new Map<String,Object> {'Name' => 'Salesforce'},true);

        Contact attendee = (Contact)TestDataFactory.createSObject('Contact',new Map<String,Object> {
            'LastName' => 'Contact 1',
            'Account' => acc}
            ,true);

        Case request = (Case)TestDataFactory.createSObject('Case', new Map<String,Object> {
            'Origin' => 'Phone',
            'Account' => acc   
        },false);

        Test.startTest();
        Database.SaveResult result = Database.insert(request, false);
        Test.stopTest();

        System.assert(result.isSuccess());

    }


    @isTest
    public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanThreeForPhoneCases(){

        Account acc = (Account)TestDataFactory.createSObject('Account',new Map<String,Object> {'Name' => 'Salesforce'},true);

        List<Contact> attendeesList = TestDataFactory.createSObjectList('Contact',new Map<String,Object>{
            'LastName' => 'Test',
            'Account' => acc
        },4);

        Case request = (Case)TestDataFactory.createSObject('Case', new Map<String,Object> {
            'Origin' => 'Phone',
            'Account' => acc
        },false);
        
        Test.startTest();
        Database.SaveResult result = Database.insert(request, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals(Label.OnlyThreeAttendeeForPhone, result.getErrors()[0].getMessage());
    }
    
    @isTest
    public static void bookEventFromTheWeb(){
        
        Account acc = (Account)TestDataFactory.createSObject('Account',new Map<String,Object> {'Name' => 'Salesforce'},true);

        Contact attendee = (Contact)TestDataFactory.createSObject('Contact',new Map<String,Object> {
            'LastName' => 'Contact 1',
            'Account' => acc}
            ,true);

        List<Case> request = TestDataFactory.createSObjectList('Case', new Map<String,Object> {
            'Origin' => 'Web',
            'Account' => acc   
        },2,false);

        Test.startTest();
        List<Database.SaveResult> result = Database.insert(request, false);
        Test.stopTest();

        System.assert(result[0].isSuccess());  
        System.assert(result[1].isSuccess());   
 
    } 
        
    @isTest
    public static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanOneForWebCases(){

        Account acc = (Account)TestDataFactory.createSObject('Account',new Map<String,Object> {'Name' => 'Salesforce'},true);

        List<Contact> attendeesList = TestDataFactory.createSObjectList('Contact',new Map<String,Object>{
            'LastName' => 'Test',
            'Account' => acc
        },2);

        Case request = (Case)TestDataFactory.createSObject('Case', new Map<String,Object> {
            'Origin' => 'Web',
            'Account' => acc
        },false);

        Test.startTest();
        Database.SaveResult result = Database.insert(request, false);
        Test.stopTest();

        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals(Label.OnlyOneAttendeeForWeb, result.getErrors()[0].getMessage());
            
    } 

    @IsTest 
    public static void testConfirmReservation(){

        Account acc = (Account)TestDataFactory.createSObject('Account',new Map<String,Object> {'Name' => 'Salesforce'},true);

        Contact attendee = (Contact)TestDataFactory.createSObject('Contact',new Map<String,Object> {
            'LastName' => 'Contact 1',
            'Email' => 'email@gmail.com',
            'Account' => acc}
            ,true);

        Case request = (Case)TestDataFactory.createSObject('Case', new Map<String,Object> {
            'Status' => 'New',
            'Origin' => 'Phone',
            'Account' => acc   
        },true);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExternalServiceCalloutMock(200,'Complete','[{"Name": "Test1"}]'));
        request.Status = 'Closed';
        Database.SaveResult result = Database.update(request, false);
        Test.stopTest();

        System.assert(result.isSuccess());   


    }

}