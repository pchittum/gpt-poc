public with sharing class GptRequestBody {
    public GptRequestBody(String model, Decimal temperature) {
        this.model = model;
        this.temperature = temperature;

        this.messages = new List<GptMessage>();
    }
    public String model {get;set;}
    public Decimal temperature {get;set;}
    public List<GptMessage> messages {get;set;}
}