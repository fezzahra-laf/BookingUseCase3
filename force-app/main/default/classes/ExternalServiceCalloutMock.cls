@isTest
public class ExternalServiceCalloutMock implements HttpCalloutMock{

    public Integer responseCode;
    public String  responseBody;
    public String  responseStatus;

    public ExternalServiceCalloutMock(Integer responseCode, String responseStatus,String responseBody){

        this.responseCode = responseCode;
        this.responseBody = responseBody;
        this.responseStatus = responseStatus;
    }

    public HttpResponse respond(HttpRequest req) {

        HttpResponse response = new HttpResponse();

        String endpoint = req.getEndpoint();
        response.setStatusCode(this.responseCode);
        response.setBody(this.responseBody);
        response.setStatus(this.responseStatus);

        return response;
    }
    
}