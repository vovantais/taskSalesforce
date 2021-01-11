@isTest
public class FindDuplicateCaseTest {
   
   @testSetup static void setup(){
   
   Account acc = new Account(
      Name='Test Account',
      Language__c ='RU'
   );
   insert acc;  
      
   Case cas = new Case(
      Subject ='test',
      SuppliedEmail ='vlad@mail.ru',
      Reason = 'Installation',
      Description=null,
      Status ='New',
      Priority = 'Low',
      Origin = 'Email',
      SuppliedName__c =null,
      AccountId= acc.Id
   );
   insert cas; 
      
   Database.DMLOptions dml = new Database.DMLOptions(); 
   dml.DuplicateRuleHeader.allowSave = true;
      
   Case dublcase = new Case(
         Subject ='test',
         SuppliedEmail ='vlad@mail.ru',
         Reason = 'Installation',
         Description='test',
         Status ='New',
         Priority = 'Medium',
         Origin = 'Email',
         SuppliedName__c ='hirocy',
         ParentId = cas.Id,
         AccountId= acc.Id
   );
         
   Database.SaveResult res = Database.insert(dublcase, dml);
      
   EmailMessage email = new EmailMessage(
      Incoming = True,
      FromAddress = 'test@abc.org',
      ToAddress= 'test@xyz.org',
      Subject = 'Test email',
      HtmlBody = 'Test email body',
      ParentId = dublcase.Id
   );
   insert email;
   }
   
   static testmethod void getMessagesTest(){
   
   List<Case> allCasesId = [SELECT Id FROM Case];
      FindDuplicateCase.getMessages(allCasesId[1].Id);
      List<EmailMessage> dataMessages = Database.query('SELECT ' + String.join(new List<String>(EmailMessage.sObjectType.getDescribe().fields.getMap().keySet()), ',') +
                                                      ' from EmailMessage WHERE ParentId=\''+String.escapeSingleQuotes(allCasesId[1].Id)+'\'');
      
      System.assertEquals('test@xyz.org',String.valueOf(dataMessages[0].ToAddress));
      
   }
   
   static testmethod void getMainCaseTest(){
      
      List<Case> allCasesId = [SELECT Id FROM Case];
      FindDuplicateCase.getMainCase(allCasesId[0].Id);
      List<Case> caseFields =[SELECT Id FROM Case WHERE  Id=:allCasesId[0].Id];
      
      System.assertEquals(1,caseFields.size()); 
   }
   
   static testmethod void  getAllCaseTest(){
      
      List<Case> allCases = [SELECT Id,Subject,Reason,SuppliedEmail FROM Case];
      FindDuplicateCase.getAllCaseWithoutMainCase(allCases[0]);
         List<Case> allCasesWithoutMainCase =[SELECT Id,Subject,SuppliedEmail,Reason,ParentId FROM Case WHERE Status!='Closed' 
                                             AND Id !=:allCases[0].Id 
                                             AND ParentId =:allCases[0].Id
                                             AND Subject=:allCases[0].Subject
                                             AND SuppliedEmail=:allCases[0].SuppliedEmail
                                             AND Reason=:allCases[0].Reason];
      
      System.assertEquals(1,allCasesWithoutMainCase.size()); 
      
   }

   static testmethod void findMergeCaseTest(){
      
      List<Case> allCasesId = [SELECT Id FROM Case];
      FindDuplicateCase.findMergeCase(allCasesId[1].Id);
      List<Case> mergeCaseFields =[SELECT Id FROM Case WHERE Id=:allCasesId[1].Id];
      
      System.assertEquals(1,mergeCaseFields.size());
      
   }
   
   static testmethod void  customNotificationTest(){
      
      FindDuplicateCase.customNotification();
      List<CustomNotificationType> typeNotify = [SELECT Id FROM CustomNotificationType WHERE DeveloperName ='MyCustomNotification'];
      
      System.assertEquals(1,typeNotify.size());
         
   }
   
   static testmethod void getCaseListDuplicateTest(){
      
      List<Case> allCasesId = [SELECT Id,Subject  FROM Case];
      List<Case> duplicateList = FindDuplicateCase.getCaseListDuplicate(allCasesId[0].Id);
      
      System.assertEquals(1,duplicateList.size());
      
      System.assertEquals(allCasesId[0].Subject, allCasesId[1].Subject);
   }
   
   static testmethod void duplicateCaseTest(){
      
   List<Case> allCases = [SELECT Id,Priority,Description,Subject,Reason,SuppliedEmail,SuppliedName__c,Origin,Status,Country__c,ParentId,
                              Account.Name,Account.Language__c FROM Case];
   
      System.assertEquals(2,allCases.size()); 
      
      update allCases[0];
      update allCases[1];
   
      FindDuplicateCase.mergeData(allCases[1].Id,allCases[0].Id,false);
      
      FindDuplicateCase.caseNotification(allCases[0].Id,true,'test'); 
            
      List<Case> Cases = [SELECT Id,Priority,Description,Subject,Reason,SuppliedEmail,SuppliedName__c,Origin,Status,Country__c,ParentId,
                           Account.Name,Account.Language__c FROM Case];
      
      List<EmailMessage> mes = [SELECT FromAddress,ToAddress  FROM EmailMessage];
      
      System.assertEquals('test@xyz.org',mes[0].ToAddress);
      
      System.assertEquals('test@abc.org',mes[0].FromAddress);
      
      System.assertEquals('Test Account',Cases[0].Account.Name);
      
      System.assertEquals('----//---- test',Cases[0].Description);
            
		System.assertEquals('Medium',Cases[0].Priority);
		
		System.assertNotEquals('E_otner - Europe other',Cases[1].Country__c);
      
		System.assertEquals('hirocy',Cases[0].SuppliedName__c);
            
      System.assertEquals('Closed',Cases[1].Status);
   }   
}