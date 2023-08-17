public with sharing class GptMessage {
    public GptMessage(String role, String content){
        this.role = role; 
        this.content = content; 
    }

    public String role{get;set;}
    public String content{get;set;}
}