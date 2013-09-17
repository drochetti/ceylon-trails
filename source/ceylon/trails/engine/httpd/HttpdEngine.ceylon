import ceylon.net.http {
    parseMethod
}
import ceylon.net.http.server {
    Server,
    createServer,
    Request,
    Response,
    Matcher,
    Options,
    AsynchronousEndpoint
}
import ceylon.trails.engine {
    WebEngine,
    RequestContext
}
import ceylon.trails.http {
    HttpMethod
}
import ceylon.trails.routing {
    MappedRoute
}
import ceylon.trails.uri {
    UriPattern
}


class UriPatternMatcher(UriPattern pattern) extends Matcher() {

    shared actual Boolean matches(String path) => pattern.matches(path);
    
    shared actual String relativePath(String requestPath) => requestPath;

}

shared class HttpdEngine(
            Integer port = 8080,
            String host = "localhost",
            Options serverOptions = Options())
        extends WebEngine() {

    Server server = createServer(empty);

    shared actual String name = "undertow";
    
    shared actual void start() => server.start(port, host, serverOptions);
    
    shared actual void stop() => server.stop();

    shared actual void bindRoutes(MappedRoute* routes) {
        for (route in routes) {
            bindRoute(route);
        }
    }

    shared void bindRoute(MappedRoute route) {
        server.addEndpoint(AsynchronousEndpoint {

            acceptMethod = route.methods.map(
                (HttpMethod m) => parseMethod(m.string));

            path = UriPatternMatcher(route.uriPattern);

            void service(Request request, Response response, void complete()) {
                handleRoute(RequestContext {
                    mappedRoute = route;
                    request = request;
                    response = response;
                });
                complete();
            }
        });
    }

}