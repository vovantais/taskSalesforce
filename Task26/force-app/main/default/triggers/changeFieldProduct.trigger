trigger changeFieldProduct on Product2 (after insert, after update) {
   TriggerDispatcher.run(new changeFieldProductHandler(),Trigger.operationType);
}