public  class ExternalSystemService {

    @future(Callout = true)
    public static void registerAttendees(Set<Id> accounts){

        List<Contact> attendees = new List<Contact>();
        
        JSONGenerator body = JSON.createGenerator(true);  
        for(Contact attendee : [SELECT Id, Name, Email FROM Contact WHERE AccountId IN: accounts]){

            body.writeStartObject(); 
            body.writeStringField('name', attendee.name + '-' + attendee.email);    
            body.writeEndObject(); 
            
            attendees.add(attendee);
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ReservationExternalSystemEndpoint');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(body.getAsString());

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            notifyAttendeeByEmail(attendees);
            
        } 
        else{
            Log.error('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        }
    
    } 

    public static void notifyAttendeeByEmail(List<Contact> attendees){

        EmailTemplate emailTemp = [SELECT Id, Subject, Body FROM EmailTemplate WHERE DeveloperName = 'NotifyAttendees'];

        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

        for(Contact attendee : attendees){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTemplateId(emailTemp.Id);
            mail.setTargetObjectId(attendee.Id);
            emailList.add(mail);
        }
        if(!emailList.isEmpty()){
            Messaging.sendEmail(emailList);
        } 
  
    }

}
