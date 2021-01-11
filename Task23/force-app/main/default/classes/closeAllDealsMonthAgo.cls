global class closeAllDealsMonthAgo implements 
   Database.Batchable<SObject>, Database.Stateful{ 

   static final String CLOSED_WON ='Closed Won';
   static final String CLOSED_LOST ='Closed Lost';   
   List<Opportunity> listRecords = new List<Opportunity>();
   Map<Id,Opportunity> updateData = new Map<Id,Opportunity>();

   global Database.QueryLocator start(Database.BatchableContext BC){
         String query = 'Select Id, Name, CloseDate,createdDate,StageName From Opportunity WHERE CloseDate=THIS_MONTH AND' + 
            '(StageName!=\''+String.escapeSingleQuotes(CLOSED_WON)+'\' OR StageName!=\''+String.escapeSingleQuotes(CLOSED_LOST)+'\')';
         return Database.getQueryLocator(query);
	}
	
   global void execute(Database.BatchableContext BC, List<SObject> scope){
      for(Opportunity obj : (Opportunity[]) scope){  
         if(Date.Today()>obj.CloseDate){
            obj.StageName = CLOSED_LOST;
            listRecords.add(obj);
         }
         if(Date.Today()>obj.createdDate.addMonths(1)){
            obj.StageName = CLOSED_LOST;
            obj.CloseDate= Date.today();
            listRecords.add(obj);
         }
      }
      if(!listRecords.isEmpty()){
         updateData.putAll(listRecords);
         update updateData.values();
      }
   }
   global void finish(Database.BatchableContext BC){}      
}