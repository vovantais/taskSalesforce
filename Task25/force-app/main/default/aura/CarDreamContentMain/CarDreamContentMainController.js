({
   doInit : function(component, event, helper) {
      helper.getData(component, event, helper);
   },
   showCardItem : function(component, event, helper){
      helper.displayCard(component, event, helper);
   },
   closeModel : function(component, event, helper) {
      component.set("v.isOpen", false);
   },
   showSliderValue : function(component, event, helper) {
      helper.rangeValue(component, event, helper);
   },
   getImage : function(component, event, helper) {
      const name='search';
      const img ={image:$A.get('$Resource.'+name)};
      component.set("v.img",img);
   },
   searchCar : function(component, event, helper){
      helper.search(component, event, helper); 
   },
   searchCarResult :function(component, event, helper){
      event.preventDefault();
      const result=component.get("v.searchResult");  
      component.set("v.listProd",result);  
   }
})