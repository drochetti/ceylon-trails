import ceylon.net.http.server {
    Session
}

// TODO support Vertx user Session (how?)
class SessionAdapter() satisfies Session {

    shared actual Integer creationTime = 0;
    
    shared actual Object? get(String key) => null;
    
    shared actual String id = "";
    
    shared actual Integer lastAccessedTime = 0;
    
    shared actual void put(String key, Object item) {}
    
    shared actual Object? remove(String key) => null;
    
    shared actual variable Integer? timeout = null;
    
}