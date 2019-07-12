trigger Translated_text on unbabelapi__Unbabel_Translation_Request__c (after update) {
    for(unbabelapi__Unbabel_Translation_Request__c request : trigger.new){
        
        if(request.unbabelapi__Unbabel_Status__c == 'Request Error'){
            Translated_text.setStatus(request.unbabelapi__Unbabel_sObject_Id__c, request.unbabelapi__Unbabel_Status__c);
            
        }
        if(request.unbabelapi__Unbabel_Status__c == 'Message Translated'){
            Translated_text.setStatus(request.unbabelapi__Unbabel_sObject_Id__c, request.unbabelapi__Unbabel_Status__c);
            Translated_text.setTranslatedText(request);
        }
    }

}