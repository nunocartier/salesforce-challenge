public with sharing class Controller implements Queueable, Database.AllowsCallouts{

    public PageReference deleteDB() {
        if(!translations.isEmpty()){
            delete translations;           
        }
        return null;
    }


    public String selectedLanguageOutput{ get; set; }
    public String selectedLanguageInput{ get; set; }
    public List<SelectOption> languagesList{get;set;}
    public List<Translation__c> translations{get;set;}
    public Translation__c translation{get;set;}

    public Controller() {
        translation = new Translation__c();
        getTranslations();      
        getLanguagesList();     
    }
    
     public void getTranslations() {
            
            translations = [SELECT Id, From_language__c , To_Language__c, Original_Text__c, Translated_Text__c, Status__c
                           FROM Translation__c];
                            
            translations.sort();
                            
    }
    
    
    public List<SelectOption> getLanguagesList(){
    
        languagesList = new List<SelectOption>();
        Schema.DescribeFieldResult languagesField = Translation__c.List_of_Languages__c.getDescribe();
        List<Schema.PicklistEntry> languagesFieldContent = languagesField.getPicklistValues();
        for(Schema.PicklistEntry entry : languagesFieldContent){
            languagesList.add(new SelectOption(entry.getValue(), entry.getLabel().substringAfter(':')));
        } 
            
        return languagesList ;
    }
    
    public void submit() {
        if(translation.Original_Text__c ==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'This field cant be empty, please enter a text to be translated.'));
        }else if(selectedLanguageInput == selectedLanguageOutput){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'The language to be translated from cant be the same has the language translated to.'));
        }else{
        
            translation.From_language__c = selectedLanguageInput.substringAfter(':');
            translation.To_Language__c = selectedLanguageOutput.substringAfter(':');
           
            insert translation;
            getTranslations();
            System.enqueueJob(this);
            
        
        } 
    }   
   
   
  public void execute (QueueableContext context){
   
  
        //****** Create Translation Request(TR) ****** 
            translation = [SELECT Id, Original_Text__c FROM Translation__c Where id = :translation.id ];       
        
            unbabelapi__Unbabel_Translation_Request__c tr = new unbabelapi__Unbabel_Translation_Request__c();
            
            tr.unbabelapi__Unbabel_From_Language__c = selectedLanguageInput.substringBefore(':');
            tr.unbabelapi__Unbabel_To_Language__c = selectedLanguageOutput.substringBefore(':');
            tr.unbabelapi__Unbabel_Translation_Type__c = 'Machine';
            tr.unbabelapi__Unbabel_Namespace__c = '';
            tr.unbabelapi__Unbabel_Class__c = 'GenericTranslationHandler';
            
            
            //Optional - if this is not defined, all the queried text fields will be translated
            Set<String> translatedFields = new Set<String>{'Original_Text__c'};
            
            //Request Translation to Unbabel
            unbabelapi.UnbabelRestEnvelope ure = unbabelapi.UnbabelRestConnectorOutbound.requestTranslation( translation , tr, translatedFields );
            
            
            //Sets the TR fields
            tr.unbabelapi__Unbabel_sObject_Id__c = translation.id;
            tr.unbabelapi__Unbabel_sObject__c = '';
            
            //if request is successfull updates the Translation Request status to "Translation Requested" and inserts the TRs            
            if (ure.isSuccess) {    
                tr.unbabelapi__Unbabel_Status__c = 'Translation Requested';
                tr.unbabelapi__Unbabel_Translation_Requested_Datetime__c = System.now();
              
            //If the request fails (ex: Unbabel core is down) updates the Translation Request status to "Request Error" and inserts the TRs
            } else {
                tr.unbabelapi__Unbabel_Status__c = 'Request Error';
                tr.unbabelapi__Unbabel_Error_Log__c = ure.message;
            }
            
           insert tr;
             
            translation = new Translation__c();
            getTranslations();
            getLanguagesList();
       
   
   }
}