@isTest
public class Translation_test {
    
    @isTest
    public static void simpleTrans(){
        
        Translation__c translation = new Translation__c();
        translation.Original_Text__c = 'Welcome';
        
        Controller controller = new Controller();
        controller.translation = translation;
        controller.selectedLanguageInput = 'en:English';
        controller.selectedLanguageOutput = 'pt:Portuguese';
        controller.submit();
        
        List<Translation__c> response = [SELECT Translated_text__c from Translation__c];
        
        system.assertEquals(1, response.size());

    }
    
    @isTest
    public static void deleteDB(){
        
        Translation__c translation = new Translation__c();
        translation.Original_Text__c = 'Welcome';
        translation.From_Language__c = 'English';
        translation.To_Language__c = 'Portuguese';
        
        Controller controller = new Controller();
        controller.translation = translation;

        insert translation;
        
        controller.deleteDB();

        system.assertEquals(true, controller.translations.isEmpty());

    }
    
    @isTest
    public static void translatedStatus(){
        
        translation__c trans = new translation__c();
        trans.From_Language__c = 'English';
        trans.To_Language__c = 'Portuguese';
        trans.Original_Text__c = 'Welcome';
        trans.Status__c = 'Translation Requested';
        insert trans;
        trans = [select id, From_Language__c, To_Language__c, Original_Text__c, Status__c
             from translation__c
             where id = :trans.id];
        Translated_text.setStatus(trans.id, 'Message Translated');
        trans = [select id, From_Language__c, To_Language__c, Original_Text__c, Status__c
             from translation__c
             where id = :trans.id];
        system.assertEquals('Message Translated', trans.Status__c);
    }
    
    @isTest
    public static void translatedText(){
        
        translation__c trans = new translation__c();
        trans.From_Language__c = 'English';
        trans.To_Language__c = 'Portuguese';
        trans.Original_Text__c = 'Welcome';
        trans.Status__c = 'Translation Requested';
        insert trans;
        trans = [select id, From_Language__c, To_Language__c, Original_Text__c, Status__c
             from translation__c
             where id = :trans.id];
        
        unbabelapi__Unbabel_Translation_Request__c tr = new unbabelapi__Unbabel_Translation_Request__c();
        tr.unbabelapi__Unbabel_From_Language__c = 'en';
        tr.unbabelapi__Unbabel_To_Language__c = 'pt';
        tr.unbabelapi__Unbabel_Translation_Type__c = 'Machine';
        tr.unbabelapi__Unbabel_Namespace__c = '';
        tr.unbabelapi__Unbabel_Class__c = 'GenericTranslationHandler';
          
        //Sets the TR fields
        tr.unbabelapi__Unbabel_sObject_Id__c = trans.id;
        tr.unbabelapi__Unbabel_sObject__c = '';
        insert tr;
        
        Attachment att = new Attachment();
		att.Name='Unit Test Attachment';
        att.Body=Blob.valueOf('{"message":null,"language":null,"isSuccess":true,"dataNoObj":null,"data":{"attributes":{"type":"Translation__c","url":"/services/data/v46.0/sobjects/Translation__c/a062p00001r5uc2AAA"},"Original_Text__c":"Bem-vindas!","Id":"a062p00001r5uc2AAA"}}');
		att.ParentId = tr.id;
		insert att;
        
        Translated_text.setTranslatedText(tr);
        
        
        
        
        trans = [select id, Translated_text__c
             from translation__c
             where id = :trans.id];
        
        system.assertEquals('Bem-vindas!', trans.Translated_text__c);
    }
    
    @isTest
    public static void no_params(){
        
        Translation__c translation = new Translation__c();
        translation.Original_Text__c = null;
        
        Controller controller = new Controller();
        controller.translation = translation;
        controller.selectedLanguageInput = 'en:English';
        controller.selectedLanguageOutput = 'pt:Portuguese';
   
		
        controller.submit();
        List<ApexPages.Message> msgList = ApexPages.getMessages();

        for(ApexPages.Message msg :  ApexPages.getMessages()) {
        	System.assertEquals('This field cant be empty, please enter a text to be translated.', msg.getDetail());
      	
        }
    }
    
    @isTest
    public static void equalsLanguages(){
        
        Translation__c translation = new Translation__c();
        translation.Original_Text__c = 'Welcome';
        
        Controller controller = new Controller();
        controller.translation = translation;
        controller.selectedLanguageInput = 'en:English';
        controller.selectedLanguageOutput = 'en:English';

        controller.submit();
        List<ApexPages.Message> msgList = ApexPages.getMessages();

        for(ApexPages.Message msg :  ApexPages.getMessages()) {
        	System.assertEquals('The language to be translated from cant be the same has the language translated to.', msg.getDetail());
   
        }
    }
    
    
	
}