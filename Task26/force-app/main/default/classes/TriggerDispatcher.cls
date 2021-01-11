public class TriggerDispatcher {

   public static void run (TriggerInterface handler, System.TriggerOperation operationType){
      switch on operationType {   
               when AFTER_INSERT {
                  handler.afterInsert(trigger.new, trigger.newMap);
               }
               when AFTER_UPDATE {
                  handler.afterUpdate(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
               }
         }
   }
}