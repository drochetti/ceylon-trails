import ceylon.net.http.server {
    Server,
    createServer,
    AsynchronousEndpoint,
    Request,
    Response,
    Matcher,
    Options
}
import ceylon.trails.engine {
    WebEngine, RequestContext
}
import ceylon.trails.routing {
    MappedRoute
}
import ceylon.trails.uri {
    UriPattern
}

class UriPatternMatcher(UriPattern pattern) extends Matcher() {

    //shared actual Boolean matches(String path) => pattern.matches(path);
    shared actual Boolean matches(String path) {
        print("path -> ``path``");
        print("pattern -> ``pattern.pattern``");
        print("pattern matcher -> ``pattern.patternMatcher``");
        print("pattern test -> ``pattern.matches(path)``");
        print("-----------------------------");
        return pattern.matches(path);
    }
    
    shared actual String relativePath(String requestPath) => requestPath;

}

shared class HttpdEngine(
            Integer port = 8080,
            String host = "localhost",
            Options serverOptions = Options())
        satisfies WebEngine {
    
    Server server = createServer({});

    shared actual String name = "undertow";
    
    shared actual void start() => server.start(port, host, serverOptions);
    
    shared actual void stop() => server.stop();

    shared actual void bindRoutes(MappedRoute* routes) {
        for (mappedRoute in routes) {
            server.addEndpoint(AsynchronousEndpoint {
                path = UriPatternMatcher(mappedRoute.uriPattern);
                void service(Request request, Response response, void complete()) {
                    print("request handled!");
                    print(mappedRoute.uriPattern.pattern);
                    print(mappedRoute.handlerRef);
                    print("---------------------");
                    handleRoute(RequestContext {
                        mappedRoute = mappedRoute;
                        request = request;
                        response = response;
                    });
                    complete();
                }
                acceptMethod = {};
            });
        }
    }

}