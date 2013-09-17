import ceylon.trails.engine {
    RequestContext
}
import ceylon.trails.routing {
    MappedRoute
}

import org.vertx.java.core {
    Handler
}
import org.vertx.java.core.http {
    HttpServerRequest
}

shared class MappedRouteHandler({MappedRoute*} routes,
        void handleRequest(RequestContext context))
        satisfies Handler<HttpServerRequest> {

    shared actual void handle(HttpServerRequest req) {
        value mappedRoute = routes.find(
            (MappedRoute route) => route.uriPattern.matches(req.uri()));
        if (exists mappedRoute) {
            // TODO test methods
            print("Found 1 route ``mappedRoute.uriPattern.pattern``");
            value response = req.response();
            handleRequest(RequestContext {
                mappedRoute = mappedRoute;
                request = RequestAdapter(req);
                response = ResponseAdapter(response);
            });
            response.end();
        }
    }

}