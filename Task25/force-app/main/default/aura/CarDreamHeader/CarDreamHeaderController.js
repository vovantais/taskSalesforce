({
   getImage : function(component, event, helper) {
      const name='carDream';
      const img ={image:$A.get('$Resource.'+name)};
      component.set("v.img",img);
   }
})