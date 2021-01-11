({
   getImage : function(component, event, helper) {
      const name='required';
      const img ={image:$A.get('$Resource.'+name)};
      component.set("v.img",img);
   },
   getDataForm : function(component, event, helper){ 	
      helper.dataProcessingForm(component, event, helper);
   },
   getFieldSelect:function(component, event, helper){
      const feildSelect = event.target.value;
   component.set("v.getval",feildSelect);
   }
})