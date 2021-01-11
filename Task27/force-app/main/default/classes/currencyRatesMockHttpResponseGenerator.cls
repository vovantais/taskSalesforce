@isTest
global  class currencyRatesMockHttpResponseGenerator  implements HttpCalloutMock {

   static final String  API_CURS_RATES= 'https://www.nbrb.by/api/exrates/rates?periodicity=0';
   static final Integer RESPONSE_CODE = 200;
   static final String RESPONSE_HEADER_KEY = 'Content-Type';
   static final String RESPONSE_HEADER_VALUE = 'application/json;charset=UTF-8';
   static final String RESPONSE_BODY = '[{"Cur_ID": 170,"Date": "2021-01-11T00:00:00","Cur_Abbreviation": "AUD","Cur_Scale": 1,"Cur_Name": "Австралийский доллар","Cur_OfficialRate": 2.0029}]';
   
   global HTTPResponse respond(HTTPRequest request){
      
      System.assertEquals(API_CURS_RATES, request.getEndpoint());
      System.assertEquals('GET', request.getMethod());

      HttpResponse res = new HttpResponse();
      res.setHeader(RESPONSE_HEADER_KEY, RESPONSE_HEADER_VALUE);
      res.setBody(RESPONSE_BODY);
      res.setStatusCode(RESPONSE_CODE);
      return res;
   }
}