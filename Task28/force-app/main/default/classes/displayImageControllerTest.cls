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

      displayImageController.getImage(acct.Id);

      List<ContentDocumentLink> cdLink =[SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId=:acct.Id];  
      
      System.assertEquals(1,cdLink.size());
      
   }
}