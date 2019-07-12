public class Translated_text {
   
    public static void setStatus(string id, string st){
        translation__c t = [select id, name, Status__c from translation__c where Id = :id];
        t.Status__c = st;
        update t;        
    }
    
    public static void setTranslatedText(unbabelapi__Unbabel_Translation_Request__c request){
        id i;      
        attachment att = [select id,body from attachment where ParentId = :request.id limit 1];
        translation__c t = [select id, Translated_Text__c from translation__c where Id = :request.unbabelapi__Unbabel_sObject_Id__c];
        blob b = att.body;
        string s = b.toString();
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(s);   
        String translated_text = String.valueof(m.get('data')).substringAfterLast('Original_Text__c=').substringBefore(', attributes');
        t.Translated_Text__c = translated_text;
        update t;
       // TODO: Capturar o valor do texto traduzido de forma mais eficiente
        
    }
}