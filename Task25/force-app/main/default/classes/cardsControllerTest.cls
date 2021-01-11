@isTest   
public class cardsControllerTest {

   @testSetup static void setup(){
      Product2 prod = new Product2();
      prod.Family = 'auto';
      prod.Name ='bmw';
      prod.IsActive__c =true;
      prod.Price__c =10000;
      prod.Year__c = Date.today();
      prod.Description ='New car';
      
      insert prod;
   }
   static testMethod void  testCards(){

   cardsController.getProductAuto();
   Product2  prod=[SELECT Id,Family FROM Product2 WHERE Family='auto' AND IsActive__c=true];
      
	System.assertEquals('auto', String.valueOf(prod.Family));
   }
}