public class cardsController {
	
   @AuraEnabled
   public static List<Product2> getProductAuto(){
      List<Product2> listProd = [SELECT Id,Family,Name,IsActive__c,Price__c,Year__c,Description FROM Product2 WHERE Family='auto' AND IsActive__c=true];  
      return listProd;
   }
}