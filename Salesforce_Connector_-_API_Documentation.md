# Salesforce Connector - API Documentation
----------




# Getting Started

The Unbabel API allows you to automatically translate large volumes of content, with human quality, between more than 50 language pairs. This high scalability is achieved by our community of more than 40K translators, empowered with Unbabel's Artificial Intelligence technology.

The following diagram illustrates Unbabel's translation process:


![](https://d2mxuefqeaa7sj.cloudfront.net/s_45EE62E2A7366E9C9CDB0DC60FA3A995414A0A7798412FAFC1116FA6D2808199_1540216361250_image.png)


It's important to understand that each translation request involves human processing. For this reason, all responses are asynchronous.

"Unbabel Connector for Salesforce" is an App that allows you to easily connect to Unbabel translation engine. You just need to:


1. Install the App (follow the installation guide).
2. Read this doc (thoroughly).
3. Start requesting translations!

All the translation flow is dealt by the App, you just need to adapt your process in order to request and process the translations.

All of our main products are currently built on top of the Unbabel Connector App: 


![](https://d2mxuefqeaa7sj.cloudfront.net/s_3FAA1D51547000594B440C42C176E41EAD988B140424D27434BCC392E9520F13_1540219132188_image.png)

1. A translation is requested for a message.
2. The Connector Application redirects the original message to Unbabel Core.
3. As soon as it is ready, the translated message is sent back to the Connector.
4. The Connector redirects the translated message to the corresponding integration

In the same way, your implementation will also be build on top of the Unbabel Connector App.


## Register, Topics and Translation Instructions 

To help Unbabel Editors translate your content in the best possible way, each translation request should have as much context as possible. Each request will be populated with the following information:


- **register** that Unbabel Editors should take into account when working on the translation, you can select one of the following: "Informal", "Formal"


- **topics** to help Unbabel choose the more appropriate Editors for your type of content, examples are "travel", "technology" or "sports"


- **instructions** to be shown to Editors while they are working on your translation, examples are "This is a product description for an e-commerce website", "This is a customer support ticket for a travel website" or "Please open www.example.com for reference"

It's very important that you provide as much of this information as possible so that our CS team can create a customised Unbabel account for your production requests. All of this information will be handled automatically on each translation request.


## Glossary and Style Guide

Are there any terms, like brands or product features, that should not be translated? Should the communication be formal or informal? For this reason, each Unbabel account has associated one **Brand** and each brand has Glossary.
Depending on your type of content, our Customer Success Team may ask you for sample content or references that can be used to speed up the creation of the Glossary and Style Guides. 

In the next chapter we explain how to create a customised production account.

# Tutorials

The Unbabel Connector allows every developer to access and integrate the Unbabel translation engine on their own applications inside Salesforce. Along this document, we describe all the methods available in order to give you all the tools necessary to implement a solution on your own.


## Installation

Please follow the instruction on the Unbabel Connector Installation Guide in order to place the App running on your Salesforce Org. After that you are good to go! Best of luck!


## API Usage Notes

Keep in mind when using the Unbabel Connector:

- All the API requests to Unbabel are handled for you. Upon setup, you will be provided with a token in order to authenticate the application requests.
- A *Translation Request* record needs to be created each time a translation is requested. It needs to be created beforehand, and  it is necessary to process the translation response. The *Translation Request* sObject is used to log all the information for each request (translation status, origin, object being translated, requested/received datetimes, error logs, etc). 
- You need to implement a class ( by extending the *ITranslationHandler* interface) in order to process each received translation.


## Setting Up an Account 

**Staging Account**

You can try out the Unbabel Connector API for free. In the staging environment, each request is processed automatically using machine translation with no involvement of Unbabel Editors (otherwise, we would have to pay for their work time). In case you request a human translation, the translation will be stuck in the flow as there will be no editors involved in this process. 


**Production Account**

As soon as your application is ready, you may want request a paid production account. With this account  you will have the access to all the previously described features:

- Custom Machine Translation engines using state-of-the-art Neural Machine Translation (NMT) adapted to our customers’ domains. 
- Customer glossaries and style guides.
- A Community of professional translators and native speakers.

And so on.

You might want to start a trial before distributing your application to your customers or even start using it internally. A Trial uses a production account and therefore allows you to check both quality and speed of translations.

Please contact our customer happiness team (*customer.happiness@unbabel.com*) to help you setting up the account.


## Translating "Hello, World!"

Assuming that you have been reading and following the document steps so far, you should have an account already set up by now. You are ready to request your first translation! You just need to:


1. Create a handler class for the translation response.
2. Use the given script to request a translation.

**Create an handler class**

This class implements the global interface *ITranslationHandler* on the Unbabel Connector package in order to process the translation response. Here is a simple example of a handler class:


``` java
    /*
            Generic handler class
    */
    
    global class GenericTranslationHandler implements unbabelapi.ITranslationHandler{
        
        global unbabelapi.UnbabelRestEnvelope execute(unbabelapi.UnbabelRestEnvelope env, unbabelapi__Unbabel_Translation_Request__c tr) {
            
                    // Response envelope
                    system.debug('env :: ' + env);
                    
                    // sObject payload
                    system.debug('env.data : ' + env.data);
                    // Generic payload
                    system.debug('env.dataNoObj : ' + env.dataNoObj);
                    // translation success
                    system.debug('env.isSuccess :: ' + env.isSuccess);
                    // error message
                    system.debug('env.message :: ' + env.message);
    
                    //Add your code
                    //
                                        
            return env;
        }    
    }
```



**Request a translation (anonymous script)**

Go to the `Developer Console → Anonymous Window` and run the following script:

**NOTE: Don't forget to specify the handler class (line 30)**

``` java
    /*
    Use Case: Generic Object
        1. Define object to translate
        2. Define a Translation Request (TR)
    */
    
    //****** Message ******
    
    public class Message {
    
        public String Id;
        public String content;
        
        public Message( String Id, String content) {
            this.Id = Id;        
            this.content = content;
        }
    }
    
    //****** Create Translation Request(TR) ******
    
    unbabelapi__Unbabel_Translation_Request__c tr = new unbabelapi__Unbabel_Translation_Request__c();
    
    tr.unbabelapi__Unbabel_From_Language__c = 'en';
    tr.unbabelapi__Unbabel_To_Language__c = 'pt';
    tr.unbabelapi__Unbabel_Translation_Type__c = 'Machine';
    tr.unbabelapi__Unbabel_Namespace__c = '';
    
    //specify the name of the class to handle the translation
    tr.unbabelapi__Unbabel_Class__c = 'GenericTranslationHandler';
    
    
    Message message = new Message('msg_0001','hello world!');
    
    //Request Translation to Unbabel
    unbabelapi.UnbabelRestEnvelope ure = unbabelapi.UnbabelRestConnectorOutbound.requestTranslation( message, tr);
    
    
    //Sets the TR fields
    tr.unbabelapi__Unbabel_sObject_Id__c = message.id;
    tr.unbabelapi__Unbabel_sObject__c = '';
    
    //if request is successfull updates the Translation Request status to "Translation Requested" and inserts the TRs            
    if (ure.isSuccess) {    
        tr.unbabelapi__Unbabel_Status__c = 'Translation Requested';
        tr.unbabelapi__Unbabel_Translation_Requested_Datetime__c = System.now();
       
    //If the request fails updates the Translation Request status to "Request Error" and inserts the TRs
    } else {
        tr.unbabelapi__Unbabel_Status__c = 'Request Error';
        tr.unbabelapi__Unbabel_Error_Log__c = ure.message;
    }
    
    insert tr;
```



Open your *Current Log*  and in the next minute it should display an entry for `unbabelapi/ReceiveTranslation/`:


![](https://d2mxuefqeaa7sj.cloudfront.net/s_EADFCE97B2B10DD53B61CDA2EAAF136250FEB0522C9C1CF6749777C597ECA078_1540923957579_Screenshot+2018-10-30+at+18.25.32.png)


**Congratulations, you just received your first translation!** 
If for some reason you can't see this entry popping up please contact us.

If you open the log you can see the response envelope printed by the handler class defined earlier:


![](https://d2mxuefqeaa7sj.cloudfront.net/s_EADFCE97B2B10DD53B61CDA2EAAF136250FEB0522C9C1CF6749777C597ECA078_1540925044635_Screenshot+2018-10-30+at+18.43.14.png)


* **data:**  Translated sObject.
* **dataNoObj:** Translated apex object.
* **isSuccess:** Translation success.
* **message:**  Error message (when translation status equals *false*).


In this case we will only have the `dataNoObj`, we translated an apex object, and `isSuccess` filled.

Let's explain briefly what just happened:

![](https://d2mxuefqeaa7sj.cloudfront.net/s_EADFCE97B2B10DD53B61CDA2EAAF136250FEB0522C9C1CF6749777C597ECA078_1540835452672_image.png)


If you go to the corresponding Translation Request (`Apps list → Unbabel API → Translation Request tab`) you can see that it was updated:


![](https://d2mxuefqeaa7sj.cloudfront.net/s_EADFCE97B2B10DD53B61CDA2EAAF136250FEB0522C9C1CF6749777C597ECA078_1540924635266_Screenshot+2018-10-30+at+18.36.54.png)


* **Status :** *Message Translated*
* **Translation Success** **:** *true*

The response envelope (JSON) was added as an attachment to the TR.  



## Translating an sObject

In order to translate an sObject you need to do the exact same steps:

1. Create a handler class for the translation response.
2. Use the given script to request a translation.

**Create an handler class**

You can use the same handler class defined above:


``` java
    /*
            Generic handler class
    */
    
    global class GenericTranslationHandler implements unbabelapi.ITranslationHandler{
        
        global unbabelapi.UnbabelRestEnvelope execute(unbabelapi.UnbabelRestEnvelope env, unbabelapi__Unbabel_Translation_Request__c tr) {
            
                    // Response envelope
                    system.debug('env :: ' + env);
                    
                    // sObject payload
                    system.debug('env.data : ' + env.data);
                    // Generic payload
                    system.debug('env.dataNoObj : ' + env.dataNoObj);
                    // translation success
                    system.debug('env.isSuccess :: ' + env.isSuccess);
                    // error message
                    system.debug('env.message :: ' + env.message);
    
                    //Add your code
                    //
                                        
            return env;
        }    
    }
```


**Request a translation (anonymous script)**

First we need to have a Salesforce object to translate. So lets' create an Email Message record. Go to the `Developer Console →Anonymous Window` and run:


``` java
    /*
        'Hello World' Email Message
    */
    
    EmailMessage em = new EmailMessage(Subject = 'Hello world!',
                                       TextBody = 'This is an email message',
                                       HtmlBody = '<p>This is an email message</p>',
                                       Incoming = true);
    
    insert em;
    
    system.debug('Email Message Id:' + em.id);
```

Recover Email Message Id from the log:

![](https://d2mxuefqeaa7sj.cloudfront.net/s_EADFCE97B2B10DD53B61CDA2EAAF136250FEB0522C9C1CF6749777C597ECA078_1540985451744_Screenshot+2018-10-31+at+11.30.02.png)


In our case, the recovered Id:  `02s1n00000PJvIoAAL`

The Email Message was created successfully, now we need to request a translation for that record. You can see that the script is very similar to the one used to request a generic translation, you just need to initialise an sObject instead of an apex object.  Run the script and don't forget to replace our Id with the one you obtained.

**NOTE: Don't forget to specify the handler class (line 20)**

``` java
    /*
    Use Case: Email Message object
        1. Define object to translate
        2. Define a Translation Request (TR)
    */
    
    //****** Get Email Message ******
    
    //change the Id for the one you obtained
    EmailMessage em = [SELECT Id,TextBody, HtmlBody, Subject FROM EmailMessage where id = '02s1n00000PJvIoAAL'];
    
    //****** Create Translation Request(TR) ******
    
    unbabelapi__Unbabel_Translation_Request__c tr = new unbabelapi__Unbabel_Translation_Request__c();
    
    tr.unbabelapi__Unbabel_From_Language__c = 'en';
    tr.unbabelapi__Unbabel_To_Language__c = 'pt';
    tr.unbabelapi__Unbabel_Translation_Type__c = 'Machine';
    tr.unbabelapi__Unbabel_Namespace__c = '';
    tr.unbabelapi__Unbabel_Class__c = 'GenericTranslationHandler';
    
    
    //Optional - if this is not defined, all the queried text fields will be translated
    Set<String> translatedFields = new Set<String>{'TextBody', 'HtmlBody','Subject'};
    
    //Request Translation to Unbabel
    unbabelapi.UnbabelRestEnvelope ure = unbabelapi.UnbabelRestConnectorOutbound.requestTranslation( em, tr,translatedFields);
    
    
    //Sets the TR fields
    tr.unbabelapi__Unbabel_sObject_Id__c = em.id;
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
```


As in the previous request, open your *Current Log*  and in the next minute it should display an entry for `unbabelapi/ReceiveTranslation/`:


![](https://d2mxuefqeaa7sj.cloudfront.net/s_EADFCE97B2B10DD53B61CDA2EAAF136250FEB0522C9C1CF6749777C597ECA078_1540923957579_Screenshot+2018-10-30+at+18.25.32.png)


And if you go to the corresponding Translation Request (`*Apps list → Unbabel API → Translation Request tab*`) you can see that it was updated:

![](https://d2mxuefqeaa7sj.cloudfront.net/s_EADFCE97B2B10DD53B61CDA2EAAF136250FEB0522C9C1CF6749777C597ECA078_1540986649320_Screenshot+2018-10-31+at+11.42.31.png)



You can have three different results here:

* **Status: Message Translated→** All went as expected, the translation was received and processed by the handler class.
* **Status: Request Error, translated message attached →** The translation was received successfully but then something went wrong during the processing. Check if you have the handler class correctly defined.
* **Status: Request Error, no translated message attached→** Something went wrong when requesting the translation. Check the field `Error Log`  containing the error message returned from Unbabel. 


##Languages

nth global value set `Languages` (`Setup → Create → Picklist Value Sets`) you can check the supported Unbabel language codes.


![](https://d2mxuefqeaa7sj.cloudfront.net/s_EADFCE97B2B10DD53B61CDA2EAAF136250FEB0522C9C1CF6749777C597ECA078_1541003474233_Screenshot+2018-10-31+at+16.31.02.png)


And the two methods described below, enable you to verify if the languages of the translation you are about to request are supported by Unbabel.

**Check Language**

You can check the content language before sending it to translation:


``` java
    // Check content language
    unbabelapi.UnbabelRestEnvelopeCL ureCL = 
        unbabelapi.UnbabelRestConnectorOutbound.checkLanguage(JSON.serialize(new EmailMessage(textBody='Hello world')));   
    
    system.debug(ureCL);
```


To retrieve the detected language: `ureCL.data.languageCode` 

This method was implemented to check the language on Email Messages so you need to always initialise an Email Message in order to check the content language. This method will be generalised on the next version of this App.

**Validate Language Pair**

You can use this method to verify if the language pair is currently supported by Unbabel:


``` java
    // Validate if Language Pair is supported
    
    String sourceLangCode = 'en'; 
    String targetLangCode = 'pt';
    
    Boolean isValid =  unbabelapi.UnbabelCustomSettingUtils.validLanguagePair(sourceLangCode, targetLangCode);
    
    system.debug('Valid LP: ' + isValid);  
```
            

`isValid` will return *true/false* depending if it is supported by Unbabel or not.


## Use Cases
----------

The following table summarises common use cases of the Unbabel Connector API and the corresponding formats that should be set on the `Content Type` field.

| **Use Case**     | **Content Type** | **Format**     |
| ---------------- | ---------------- | -------------- |
| Emails (Default) | `tickets`        | `text`  `html` |
| Chat             | `chat`           | `text`         |
| FAQs             | `kb`             | `text`  `html` |

* **tickets** → Our standard flow. Optimised for support cases/emails. Intended to be used with Case and Email Message standard sObject. 
* **chat** → Optimised flow for chat conversations.
* **kb** → Optimised flow for articles. Intended to be used with knowledge articles, but it can generalized to any FAQ like object/sObject.

This is defined when requesting a translation. Please inform us if you intend to use the Chat or FAQs flow instead of the default one.


**Tickets**

The tickets flow is the one used by default. It's described on the **Translating an sObject** chapter above.

**Chat**

The optimised Chat flow allows you to group all the messages under the same chat conversation. In order to use that you need to define:
* `Chat Key`: Id of the chat conversation. 
* `Content Type`: chat.
* `Timeout`: Time limit (in seconds) for the translation, for example 1,2 or 3 minutes, and, in that period, the best translation between machine and human will be delivered.

Follow the steps described earlier to create a handler class. then you can use this example script to request a chat message translation:


``` java
    /*
    Use Case: Chat
    
        1. Define a Translation Request (TR)
        2. Define the Chat conversation inputs
    */
    
    //****** Chat Message *******
    
    public class Message {
    
        public String Id;
        // NOTE: you need to use this exact name
        public String Unbabel_Original_Chat_Message;
        
        public Message( String Id, String Unbabel_Original_Chat_Message) {
            this.Id = Id;        
            this.Unbabel_Original_Chat_Message = Unbabel_Original_Chat_Message;
        }
    }
    
    //****** Create Translation Request(TR) ******
    
    unbabelapi__Unbabel_Translation_Request__c tr = new unbabelapi__Unbabel_Translation_Request__c();
    
    tr.unbabelapi__Unbabel_From_Language__c = 'en';
    tr.unbabelapi__Unbabel_To_Language__c = 'pt';
    tr.unbabelapi__Unbabel_Translation_Type__c = 'Machine';
    tr.unbabelapi__Unbabel_Namespace__c = 'namespace';
    //Define the handler class 
    tr.unbabelapi__Unbabel_Class__c = 'GenericTranslationHandler';
    
    //****** Chat API inputs *******
    
    // Message to be translated
    Message message = new Message('message_1','Hello world!');
    
    // Unique identifier for each chat conversation
    String chatKey = 'chat_00001';
    
    // Maximum delivery time for the translation
    String timeout = '0';
    
    // Content Type
    String contentType = 'chat';
    
    // inputs
    String inputs = contentType + '&chatkey='+ chatKey +'&timeout='+ timeout;
    
    // Fields to be translated
    Set<String> translatedFields = new Set<String>{'Unbabel_Original_Chat_Message'};
    
    unbabelapi.UnbabelRestEnvelope ure = unbabelapi.UnbabelRestConnectorOutbound.requestTranslation( message, tr, translatedFields, inputs);
    
    
    //Sets the TR fields
    tr.unbabelapi__Unbabel_sObject_Id__c = message.id;
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


**FAQs**

To use the optimised FAQs flow you only need to define `**Content Type**``: kb` when requesting the translation.


    /*
    Use Case: FAQ Object
        1. Define FAQ article to translate
        2. Define a Translation Request (TR)
    */
    
    //****** FAQ Article ******
    
    public class Article_FAQ {
    
        public String Id;
        public String description;
        public String body;
        
        public Article_FAQ( String Id, String description, String body) {
            this.Id = Id;        
            this.description = description;
            this.body = body;
        }
    }
    
    //****** Create Translation Request(TR) ******
    
    unbabelapi__Unbabel_Translation_Request__c tr = new unbabelapi__Unbabel_Translation_Request__c();
    
    tr.unbabelapi__Unbabel_From_Language__c = 'en';
    tr.unbabelapi__Unbabel_To_Language__c = 'pt';
    tr.unbabelapi__Unbabel_Translation_Type__c = 'Machine';
    tr.unbabelapi__Unbabel_Namespace__c = '';
    
    //specify the name of the class to handle the translation
    tr.unbabelapi__Unbabel_Class__c = 'GenericTranslationHandler';
    
    
    Article_FAQ faq = new Article_FAQ('faq_0001','hello world of FAQs!', 'This is the world of FAQs.');
    
    
    Set<String> translatedFields = new Set<String>{'description','body'};
    
    //Request Translation to Unbabel
    unbabelapi.UnbabelRestEnvelope ure = unbabelapi.UnbabelRestConnectorOutbound.requestTranslation(faq, tr,translatedFields,'kb');
    
    
    //Sets the TR fields
    tr.unbabelapi__Unbabel_sObject_Id__c = faq.id;
    tr.unbabelapi__Unbabel_sObject__c = '';
    
    //if request is successfull updates the Translation Request status to "Translation Requested" and inserts the TRs            
    if (ure.isSuccess) {    
        tr.unbabelapi__Unbabel_Status__c = 'Translation Requested';
        tr.unbabelapi__Unbabel_Translation_Requested_Datetime__c = System.now();
       
    //If the request fails updates the Translation Request status to "Request Error" and inserts the TRs
    } else {
        tr.unbabelapi__Unbabel_Status__c = 'Request Error';
        tr.unbabelapi__Unbabel_Error_Log__c = ure.message;
    }
    
    insert tr;
```


## Preserving variables (Anonymization) 

Unbabel does not make use of customer sensitive data of any kind. It’s simply not required and in order to reduce any privacy-related risk with our human network’s post-editing work, we automatically remove sensitive, personally-identifiable data from content before it is dispatched to them.
Credit Card numbers, Social Security numbers, URLs, dates and email addresses are all stripped out and replaced by an anonymised term block with the type of content that it hides; this helps our editors to continue working without losing the context, and ensures that private data is never put at risk. 

There might be some cases where you want keep part of the content unchanged when requesting a translation. If you add these tags around the content:  `<<< content not translated >>>`, it will keep that part of the text from being translated. These tags currently only work for Tickets and FAQs content types.

