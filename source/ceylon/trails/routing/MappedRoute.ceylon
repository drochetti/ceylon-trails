import ceylon.language.model.declaration {
    FunctionDeclaration
}
import ceylon.trails.http {
    HttpMethod
}
import ceylon.trails.uri {
    UriPattern
}

"Represents a mapped route of the application. All the info regarding a
 web request endpoint, usually a function inside a Controller class."
shared class MappedRoute(uriPattern, methods, route, controller, handlerRef)
        satisfies Comparable<MappedRoute> {

    shared UriPattern uriPattern;

    shared {HttpMethod*} methods;

    shared Route? route;

    shared Object controller;

    shared FunctionDeclaration handlerRef;

    shared actual Comparison compare(MappedRoute other) =>
        uriPattern.compare(other.uriPattern);

}