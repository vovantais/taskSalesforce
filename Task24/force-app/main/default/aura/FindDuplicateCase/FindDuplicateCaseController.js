({
   doInit: function(component, event, helper) {
      helper.getData(component, event, helper);
   },
   continueMerge:function(component, event, helper) {
      helper.continueMergeRecords(component, event, helper);
   },
   selectedRecords : function(component, event, helper) {       
      helper.mergeRecords(component, event, helper);
   },
   closeModel: function(component, event, helper) {
      component.set("v.isOpen", false);
   },
   onCheck: function(component, event,helper) {
      let checkBox=component.get("v.myBool");
      component.set("v.myBool",checkBox); 
   }
})