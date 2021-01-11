({
   getData : function(component, event, helper) {
      let action = component.get('c.getProductAuto');
      action.setCallback(this, function(response){
         if(response.getState() == 'SUCCESS'){
            if(response.getReturnValue().length>0){
               let res =response.getReturnValue();
               res.map(item=>{
                  item.image = $A.get('$Resource.'+item.Name);
                  return item;
               })
               component.set("v.listProd",res)
               component.set("v.getval",response.getReturnValue());
               }
            } else {
               console.log('::Some error occurred::');
            }
      });
      $A.enqueueAction(action);
   },
   displayCard : function(component, event, helper) {
      const response = component.get("v.getval");
      const prodid =event.currentTarget.dataset.prodid;
      let selectCar= response.filter(item=>item.Id===prodid);
      component.set('v.selectCar',selectCar[0]);
      let openModel = component.get("v.isOpen");
      component.set("v.isOpen", !openModel);
   },
   rangeValue : function(component, event, helper){
      const rangeSlider = document.getElementById("myRange");
      const rangeBullet = document.getElementById("rs-bullet");
      const response = component.get("v.getval");  
      rangeBullet.innerHTML = rangeSlider.value;
      let  rangeValue = rangeBullet.innerHTML;
      let bulletPosition = (rangeSlider.value /rangeSlider.max);
      if(rangeSlider.offsetWidth == 400){
         rangeBullet.style.left = (bulletPosition * 330) + "px";
      }else{
         rangeBullet.style.left = (bulletPosition * 205) + "px";
      }
      if (rangeValue > 0) {
         const result = response.filter(item => item.Price__c>=rangeValue);
         component.set("v.listProd",result);  
      }
   },
   search : function(component, event, helper){
      let search =event.target.value.toLowerCase();
      const response = component.get("v.getval");  
   if (search.length > 0) {
         let reg = new RegExp(`${search}{0,}`);
         const result = response.filter(item => reg.test(item.Name.toLowerCase()));
         component.set("v.searchResult",result)
   }
   }
})