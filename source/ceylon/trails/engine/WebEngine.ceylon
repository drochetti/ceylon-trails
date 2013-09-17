import ceylon.collection {
    LinkedList
}
import ceylon.language.model {
    type
}
import ceylon.net.http.server {
    Request,
    Response
}
import ceylon.trails.core {
    RequestMiddleware
}
import ceylon.trails.routing {
    MappedRoute
}


shared abstract class WebEngine() {

    shared formal String name;

    shared formal void bindRoutes(MappedRoute* routes);

    shared formal void start();

    shared formal void stop();

    LinkedList<RequestMiddleware> middlewares = LinkedList<RequestMiddleware>();

    shared default void handleRoute(RequestContext context) {
        value chosenRoute = context.mappedRoute;
        value controller = chosenRoute.controller;
        value handlerRef = chosenRoute.handlerRef;

        value handler = handlerRef.memberApply<Anything, Object?, [Request, Response]>(
            type(controller))(controller);
        // TODO how to handle any method? any number/kind of arguments, including none
        //value handler = handlerRef.memberApply<Anything, Object?, Anything[]|[]>(
        //    type(controller))(controller);

        variable Object? result = null;
        
        Object? invokeHandler() {
            // TODO discover and inject expected arguments
            return handler(context.request, context.response);
        }
        
        value it = middlewares.iterator();
        if (is RequestMiddleware middleware = it.next()) {
            Object? next() {
                if (is RequestMiddleware nextMiddleware = it.next()) {
                    return nextMiddleware.apply(context, next);
                } else {
                    return invokeHandler();
                }
            }
            result = middleware.apply(context, next);
        } else {
            result = invokeHandler();
        }
        
    }
    
    shared void bindRequestMiddlewares(RequestMiddleware* m) {
        middlewares.addAll(m);
    }

}