# Unbabel Salesforce Challenge

Hey :smile:

Welcome to our Salesforce challenge repository. This README will guide you on how to participate in this challenge.

**Please fork this repo before you start working on the challenge.** We will evaluate the challenge both on the fork and on the corresponding Salesforce Org.

**FYI:** Please understand that this challenge is not decisive if you are applying to work at [Unbabel](https://unbabel.com/jobs). There are no right and wrong answers. This is just an opportunity for us both to work together and get to know each other in a more technical way.

## Challenge


#### Application in Salesforce

Build a page (Visualforce or Lightning) composed by a page with 1 input text field, 1 picklist field, 1 button and 1 output text area:

1. **Input text field: “Text to translate:”**
	To introduce the text to be translated.
 
2.  **Picklist field: “Translate to:”**
Must present a list of languages to translate. (you can check the supported languages in the Unbabel website).
 
3.  **Button: “Submit”**
Should submit the text to our API (link in Resources) in order to be translated. (Be aware that you must check when the Response Status is completed).
 
4.  **Five column table with:**
“From Language, Original Text, To Language, Translated Text, Status".
Should present all the translations already made.
 
You can add images/fields/buttons as you seem fit. 

5. Create a Custom Object to to save these translations (ex: "Translation__c"). 


#### Considerations regarding the functionality


* The page/component that you create should automatically update the table as soon as you click on the "Submit" button with Status "Translation Requested". 

* The page/component that you create should automatically update the "Translated Text" field as soon as the translation arrives (you can use Streaming API or anything else you seem fit for this). 

* Include the validations that you seems fit (like the Text to Translate must not be empty for example).

* A user that accesses the page should only see his own translations. However a admin user should be able to see all the translations requested.

* Implement pagination to only show up to 10 translations on that table at a time.  

* The translations must be requested using the Unbabel Connector with the Content Type `Tickets` (**Ask whoever has been in contact with you about the credentials for the Salesforce Org)**.




You must also do a document **"Application Technical Scope"**  with:
* Data Model
* Technical Scope
* Use cases
 
Add as a pdf in the repository.

#### Requirements
* Create a scalable application.
* Have unit tests with assertion and code coverage >85%
* Please commit all the entities that you create/update on your fork. 

#### Resources
* Unbabel Connector - API Documentation: https://gitlab.com/Unbabel/salesforce/salesforce-challlenge/blob/master/Salesforce_Connector_-_API_Documentation.md