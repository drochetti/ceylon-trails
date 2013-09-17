import ceylon.trails.engine {
    WebEngine
}
import ceylon.trails.routing {
    MappedRoute
}

import org.vertx.java.core {
    VertxFactory
}

shared class VertxEngine(
            Integer port = 8080,
            String host = "localhost")
        extends WebEngine() {

    //value vertx = VertxFactory().newVertx(port, host);
    value vertx = VertxFactory().newVertx();
    value server = vertx.createHttpServer();

    
    shared actual String name = "vertx";
    
    shared actual void start() => server.listen(port, host);
    
    shared actual void stop() {
        server.close();
        vertx.stop();
    }
    
    shared actual void bindRoutes(MappedRoute* routes) {
        server.requestHandler(MappedRouteHandler(routes, handleRoute));
    }

}