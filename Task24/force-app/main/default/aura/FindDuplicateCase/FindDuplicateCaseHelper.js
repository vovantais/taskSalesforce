({
   getData : function(component, event, helper) {
      let action = component.get('c.getCaseListDuplicate');
      let recordId = component.get("v.recordId"); 
      action.setParams({"caseRecordID": recordId});
      action.setCallback(this, function(response){
         if(response.getState() == 'SUCCESS'){
            if(response.getReturnValue().length>0){
                  component.set("v.content",true)
                  component.set("v.duplicateCaseList", response.getReturnValue());
                  component.set("v.getval",response.getReturnValue());
               }else{
                  component.set("v.content",false)
               }
            } else {
               console.log('::Some error occurred::');
            }
      });
      $A.enqueueAction(action);
   },
   mergeRecords : function(component, event, helper) {
      const response = component.get("v.getval"); 
      let openModel = component.get("v.isOpen"); 
      let recordId = event.target.dataset.record;
      let getFields = response.filter(item=>item.Id===recordId); 
      let checkQueue = getFields[0].OwnerId.slice(0,3);
      const queue ='00G';
      let action = component.get('c.mergeData');
      if((getFields[0].Status === 'In progres' || getFields[0].Status === 'On Hold') && queue !==checkQueue){
         component.set("v.mergerecordId", recordId);
         component.set("v.isOpen", !openModel);
      }else{
         action.setParams({ "mergeRecord" :  recordId ,"caseRecordID":component.get("v.recordId")});
         $A.enqueueAction(action); 
      }   
   },
   continueMergeRecords :function(component, event, helper){
      let notification = component.get("v.myBool"); 
      let openModel = component.get("v.isOpen");
      let mergerecordId = event.target.dataset.recordid;	
      const action = component.get('c.mergeData');
      action.setParams({ "mergeRecord" :  mergerecordId ,"caseRecordID":component.get("v.recordId"),"notify":notification}); 
      $A.enqueueAction(action); 
      component.set("v.isOpen", !openModel);
   }
})