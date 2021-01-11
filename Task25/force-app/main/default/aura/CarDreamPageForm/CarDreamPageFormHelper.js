({
   dataProcessingForm : function(component, event, helper) {
      const val = component.get("v.getval");
      const selectPriority = component.get("v.selectPriority");
      if(val[0]==undefined || val[0]=='Installation' || val[0]== "General Question(default)"){
         component.set("v.selectPriority",!selectPriority);
      }else{
         component.set("v.selectPriority",selectPriority); 
      }
   }
})