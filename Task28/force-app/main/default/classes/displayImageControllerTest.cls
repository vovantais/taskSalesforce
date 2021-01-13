@isTest
public class displayImageControllerTest {
   
   @testSetup static void setup(){ 
      
      Account acct = new Account(Name='TEST');
      insert acct;
      
      ContentVersion contentVersion = new ContentVersion(
         Title = 'Penguins',
         PathOnClient = 'Penguins.jpg',
         VersionData = Blob.valueOf('Test Content'),
         IsMajorVersion = true
      );
      insert contentVersion;
      
      List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];   
      ContentDocumentLink cdl = New ContentDocumentLink(
         LinkedEntityId = acct.Id,
         ContentDocumentId = documents[0].Id,
         shareType = 'V'
      );
      insert cdl;
   }
   
   static testMethod void  testCreate(){ 
      
   Account acct =[SELECT Id FROM Account];

   List<String> linkFiles= displayImageController.getImage(acct.Id);
   List<String> linkUrl =new List<String>();

      List<ContentDocumentLink> cdLinks =[SELECT ContentDocumentId,ContentDocument.LatestPublishedVersionID FROM ContentDocumentLink WHERE LinkedEntityId=:acct.Id];
         for(ContentDocumentLink cdl: cdLinks){
            linkUrl.add(URL.getSalesforceBaseUrl().toExternalForm() +'/sfc/servlet.shepherd/version/download/'+cdl.ContentDocument.LatestPublishedVersionID);  
      }
      
      System.assertEquals(linkFiles,linkUrl);
   }
}