@isTest
public class changeFieldProductTest {
   
   @testSetup static void setup(){
   
   Account acc = new Account(
         Name = 'Test Account'
   );
	insert acc;
		
   Opportunity opp = new opportunity(
         Name='Test Account Opp' ,
         AccountId= acc.Id,
         StageName = 'Prospecting',
         CloseDate = Date.today() + 30
   );
   insert opp;
   
   Product2 prod = new Product2(
         Name = 'Test product',
         ProductCode = '795423',
         IsActive__c = true
   );
   insert prod;
      
   Id pricebookId = Test.getStandardPricebookId();
   PricebookEntry pbEntry = new PricebookEntry(
         Pricebook2Id = pricebookId,
         Product2Id = prod.Id,
         UnitPrice = 500.00,
         IsActive = true
   );
   insert pbEntry;
      
      OpportunityLineItem oli = new OpportunityLineItem(
         OpportunityId = opp.Id,
         Quantity = 1,
         PricebookEntryId = pbEntry.Id,
         TotalPrice = 1 * pbEntry.UnitPrice,
         Product2Id = prod.Id
   );
   insert oli;  

   }
   
   static testMethod void updateFieldProduct(){
      Product2 prod = [SELECT Id,IsActive__c FROM Product2];
      prod.IsActive__c = false;
      update prod;    
   }
   
   static testMethod void changeFieldProductTest(){
      Opportunity opp = [SELECT Id FROM Opportunity];
      List<Task> tsk = [SELECT Id,whatId FROM Task WHERE whatId=:opp.Id];
      System.assertNotEquals(1, tsk.size());
   }
}