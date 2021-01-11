@isTest             
private class closeAllDealsMonthAgoTest {

   @testSetup static void setup(){

      Integer count = 200;
      Account acc = new Account(Name='Test Account');
      insert acc;
      
      List<Opportunity> opps = new List<Opportunity>();
      for (integer i=0; i<count; i++){
         Opportunity opp = new Opportunity();
         opp.AccountId=acc.Id;
         opp.Name='My Opportunity '+i;
         opp.StageName='Qualification';
         opp.CloseDate= Date.today().addDays(-1);
         opps.add(opp);
		}
      insert opps; 
   } 

   static testmethod void testbatch() { 
   
      List<Opportunity> opps = [SELECT Id,StageName FROM Opportunity];
      
      Test.setCreatedDate(opps.get(0).Id, System.now().addMonths(-2));
      
      Test.startTest();
         closeAllDealsMonthAgo obj = new  closeAllDealsMonthAgo();
         Database.executeBatch(obj);
      Test.stopTest();
      
	List<Opportunity> oppUpdatedList = [SELECT Id,StageName FROM Opportunity];
      for(Opportunity o : oppUpdatedList){
            System.assertEquals('Closed Lost', o.StageName);        
      }
	}
}