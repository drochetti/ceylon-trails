import ceylon.trails.routing {
    MappedRoute
}


shared interface WebEngine {

    shared formal String name;

    shared formal void bindRoutes(MappedRoute* routes);

    shared formal void start();

    shared formal void stop();

    shared default void handleRoute(RequestContext context) {
        value chosenRoute = context.mappedRoute;
        value handler = chosenRoute.handlerRef;
        //value t = handler.parameterDeclarations.map(
        //    (FunctionOrValueDeclaration elem) => elem.openType);
        value controller = chosenRoute.controller;
        //Function<Anything,Anything[]> n = handler.bindAndApply(chosenRoute.controller);
        //n();
        for (param in handler.parameterDeclarations) {
            //value n1 = handler.
        }
        
    }

}