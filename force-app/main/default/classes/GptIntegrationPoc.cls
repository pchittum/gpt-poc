public with sharing class GptIntegrationPoc {

    private final String GPT_URL = 'https://api.openai.com/v1/chat/completions';
    private final String GPT_MODEL = 'gpt-3.5-turbo';
    private final Decimal GPT_DEFAULT_TEMPERATURE = .8; 
    private final String CONTENT_TYPE_JSON = 'application/json';

    private String authorization; 

    public GptIntegrationPoc() {
        authorization = 'Bearer ' + Auth_Token__mdt.getInstance('GPT_API_Key').key__c; 
    }

    public String getGptCompletion(String message, Decimal temperature){

        /*
        First pass at integration. For the moment relying on remote site settings
        to whitelist https://api.openai.com until the new external credentials 
        custom headers features come online. Until then, can't be bothered with 
        the clever, but hacked together way to make it work.
        */

        // TODO: move system prompt into CMDT?
        GptMessage systemMessage = new GptMessage('system', 'Pretend you are writing a story from the perspective of a teenager talking to their parents.');

        // to make a formattable string, curly brackets must be escaped by enclosing
        // single quotes, which must be escaped by backslashes! 
        // TODO: kill the string template and implement the whole request body as custom
        //       object to be serialized to JSON. 
        //       maybe consider the builder pattern: https://howtodoinjava.com/design-patterns/creational/builder-pattern-in-java/
        // also read dzone refcard on APIs: https://dzone.com/storage/assets/15773170-house-dzone-refcard-303-api-integration-patterns-2.pdf
        
        // create instance of GptRequestBody instantiated with model and temperature
        GptRequestBody reqBodyObj = new GptRequestBody(GPT_MODEL, temperature);

        // add system and user messages
        reqBodyObj.messages.add(new GptMessage('user', message));
        reqBodyObj.messages.add(systemMessage);

        Http connection = new Http();

        HttpRequest req = getGptHttpRequest(reqBodyObj);

        HttpResponse resp = connection.send(req);

        System.debug('Status Code: '+ resp.getStatusCode());
        System.debug('Status: '+ resp.getStatus());
        System.debug('Resp body: '+ resp.getBody());

        return resp.getBody(); 
    }

    public String getGptCompletion(String message){
        return getGptCompletion(message, GPT_DEFAULT_TEMPERATURE);
    }

    private HttpRequest getGptHttpRequest(GptRequestBody reqBodyParam){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(GPT_URL);
        req.setMethod('POST');
        req.setHeader('Content-Type', CONTENT_TYPE_JSON);
        req.setHeader('Authorization', authorization);
        req.setTimeout(60000);
        req.setBody(JSON.serialize(reqBodyParam));
        return req; 
    }

}