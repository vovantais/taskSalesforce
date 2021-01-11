@isTest    
public class currencyRatesTest  {
      
   static final Integer RESPONSE_CODE = 200;
   static final String RESPONSE_HEADER_KEY = 'Content-Type';
   static final String RESPONSE_HEADER_VALUE = 'application/json;charset=UTF-8';
   static final String RESPONSE_BODY = '[{"Cur_ID": 170,"Date": "2021-01-11T00:00:00","Cur_Abbreviation": "AUD","Cur_Scale": 1,"Cur_Name": "Австралийский доллар","Cur_OfficialRate": 2.0029}]';
   
   static testMethod void testGetcurrencyRates() {

      StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
      mock.setStaticResource('nbrb');
      mock.setStatusCode(RESPONSE_CODE);
      mock.setHeader(RESPONSE_HEADER_KEY, RESPONSE_HEADER_VALUE);
      Test.setMock(HttpCalloutMock.class, new currencyRatesMockHttpResponseGenerator());

      HttpResponse result = currencyRates.getResponse();
      String actualValue = result.getBody();
      
      System.assertNotEquals(null, result);

      System.assertEquals(RESPONSE_CODE, result.getStatusCode());

      System.assertEquals(RESPONSE_HEADER_VALUE,result.getHeader(RESPONSE_HEADER_KEY));
      
      System.assertEquals(actualValue, RESPONSE_BODY);
      
      List<Object> objList = currencyRates.getRates();
      System.assert(!objList.isEmpty());    
   }
}