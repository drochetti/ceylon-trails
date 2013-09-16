import ceylon.net.http.server {
    Request,
    Response
}
import ceylon.trails.routing {
    MappedRoute
}

shared class RequestContext(mappedRoute, request, response) {

    shared MappedRoute mappedRoute;

    shared Request request;

    shared Response response;

}