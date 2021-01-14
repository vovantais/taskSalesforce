public class FindDuplicateCase {

   static final String HIGH_PRIORITY='High';
   static final String LOW_PRIORITY='Low';
   static final String MEDIUM_PRIORITY='Medium';
   static final String CLOSED_CASE ='Closed';
   static final String FILLER = ' ----//---- ';
   
   @AuraEnabled
   public static List<Case> getCaseListDuplicate(Id caseRecordID){
      List<Case> duplicateCaseList = new List<Case>();
      if(caseRecordID != null){
            Case caseObject =getMainCase(caseRecordID);
         for(Case c:getAllCaseWithoutMainCase(caseObject)){
                  duplicateCaseList.add(c);
         }
   }
      return duplicateCaseList; 
   }
   
   public static Case getMainCase(Id caseRecordID){
      List<Case> caseFields =[SELECT Id,CaseNumber,Origin,Subject,SuppliedEmail,Status,Reason,OwnerId,Description,Country__c,SuppliedName__c,Priority,
                              Account.Name FROM Case WHERE Status!=:CLOSED_CASE AND Id=:caseRecordID ];
      return caseFields[0]!=null ? caseFields[0] : null;
   }
   
   public static List<Case> getAllCaseWithoutMainCase(Case caseSingle){ 
      List<Case> allCasesWithoutMainCase =[SELECT Id,CaseNumber,Origin,Subject,SuppliedEmail,Status,Reason,OwnerId,Description,Country__c,SuppliedName__c,Priority,
                                             ParentId,Account.Name FROM Case WHERE Status!=:CLOSED_CASE 
                                             AND Id !=:caseSingle.Id 
                                             AND ParentId =:caseSingle.Id
                                             AND Subject=:caseSingle.Subject
                                             AND SuppliedEmail=:caseSingle.SuppliedEmail
                                             AND Reason=:caseSingle.Reason];
         return  allCasesWithoutMainCase;
   }
   
   public static Case findMergeCase(Id mergeRecord){
      List<Case> mergeCaseFields =[SELECT Id,CaseNumber,Origin,Subject,SuppliedEmail,Status,Reason,OwnerId,Description,Country__c,SuppliedName__c,Priority,
                                    ParentId,Account.Name,Account.Language__c FROM Case WHERE Id=:mergeRecord];
      return mergeCaseFields[0];
   }
   
   public static CustomNotificationType customNotification(){
         CustomNotificationType typeNotify = [SELECT Id FROM CustomNotificationType WHERE DeveloperName ='MyCustomNotification'];
         return typeNotify;
   }
   
   public static void caseNotification(Id caseRecordID,Boolean notify,String notificationMessage){
      if(notify !=null &&  caseRecordID !=null && notificationMessage!=null &&  notify==true){
            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setTitle('Notification sent using apex!');
            notification.setBody(notificationMessage);
            notification.setSenderId(Userinfo.getUserId());
            notification.setNotificationTypeId(customNotification().Id);
            notification.setTargetId(caseRecordID);
            notification.send(new Set<String> { Userinfo.getUserId() });
      }
   }
   
   @AuraEnabled
   public static void mergeData(Id mergeRecord,Id caseRecordID,Boolean notify){
      if(mergeRecord != null && caseRecordID!=null){
         Case caseObject =getMainCase(caseRecordID);
         Case mergeCaseFields =findMergeCase(mergeRecord);
         List<EmailMessage> dataMessages =getMessages(mergeRecord);
         String notificationMessage = null;

         if(caseObject.Description != null && mergeCaseFields.Description !=null){
            caseObject.Description += FILLER + mergeCaseFields.Description; 
         }else if(caseObject.Description == null && mergeCaseFields.Description == null){
            caseObject.Description = FILLER;
         }else{
            caseObject.Description = FILLER + mergeCaseFields.Description; 
         }
         if((caseObject.Priority !=mergeCaseFields.Priority && mergeCaseFields.Priority==HIGH_PRIORITY)||
            (caseObject.Priority==LOW_PRIORITY && mergeCaseFields.Priority==MEDIUM_PRIORITY)){
            caseObject.Priority =mergeCaseFields.Priority;
         }
         if(mergeCaseFields.Account.Name!=null && caseObject.Account.Name == null ){
            caseObject.Account.Name = mergeCaseFields.Account.Name;
         }
         if(caseObject.SuppliedName__c  == null && mergeCaseFields.SuppliedName__c !=null){
            caseObject.SuppliedName__c =mergeCaseFields.SuppliedName__c ;
         }
         if(caseObject.Country__c  == null && mergeCaseFields.Country__c !=null){
            caseObject.Country__c=mergeCaseFields.Country__c;
         }
         if(mergeCaseFields.Account.Language__c == null || mergeCaseFields.Account.Language__c =='EN' ){
            notificationMessage= 'Note: Case \''+String.escapeSingleQuotes(mergeCaseFields.CaseNumber)+'\' was closed as a duplicate.';
         }else{
            notificationMessage= 'Внимание: Кейс  \''+String.escapeSingleQuotes(mergeCaseFields.CaseNumber)+'\' был закрыт как дубликат.';
         }
         
         List<EmailMessage> newMessages = new List<EmailMessage>();
            for(EmailMessage mes:dataMessages){
               newMessages.add(new EmailMessage(
               FromAddress =mes.FromAddress,
               FromName =mes.FromName,
               Headers =mes.Headers,
               MessageDate =mes.MessageDate,
               Status =mes.Status,
               Subject =mes.Subject,
               TextBody =mes.TextBody,  
               ToAddress =mes.ToAddress,
               BccAddress =mes.BccAddress,
               CcAddress =mes.CcAddress,
               ParentId =caseRecordID
               ));
            }
            insert newMessages;
            
            mergeCaseFields.Status = CLOSED_CASE;
            update mergeCaseFields;
            update caseObject;
            caseNotification(caseRecordID,notify, notificationMessage);
         
      }
   } 
   
   public static List<EmailMessage> getMessages(id mergeRecord){
      List<EmailMessage> dataMessages = Database.query('SELECT ' + String.join(new List<String>(EmailMessage.sObjectType.getDescribe().fields.getMap().keySet()), ',') +
                                                         ' from EmailMessage WHERE ParentId=\''+String.escapeSingleQuotes(mergeRecord)+'\'');        
      return dataMessages; 
   }
}