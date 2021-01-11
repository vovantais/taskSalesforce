public class displayImageController {
   
   static final String IMAGE_STORE ='/sfc/servlet.shepherd/version/download/';
   
   @AuraEnabled  
   public static List<String> getImage(Id CurrentId){
      List<String> files =new List<String>();
      if(CurrentId != null){
         List<ContentDocumentLink> cdLinks =getCdLinks(CurrentId);
         for(ContentDocumentLink cdl: cdLinks){
            files.add(URL.getSalesforceBaseUrl().toExternalForm() + IMAGE_STORE + cdl.ContentDocument.LatestPublishedVersionID);  
         }
      }
      return files;
   }
   public static List<ContentDocumentLink> getCdLinks(Id CurrentId){
      List<ContentDocumentLink> cdLinks = [SELECT ContentDocument.LatestPublishedVersionID FROM ContentDocumentLink WHERE LinkedEntityId=:CurrentId AND
                                          (ContentDocument.FileExtension='png' OR
                                          ContentDocument.FileExtension='jpg' OR 
                                          ContentDocument.FileExtension='jpeg' OR
                                          ContentDocument.FileExtension='gif')];
      return cdLinks;
   }
}