import ceylon.collection {
    LinkedList
}
import ceylon.language.meta {
    annotations
}
import ceylon.language.meta.declaration {
    Package,
    ClassDeclaration,
    FunctionDeclaration
}
import ceylon.language.meta.model {
    Class
}
import ceylon.trails.http {
    HttpMethod
}
import ceylon.trails.uri {
    UriPattern
}

shared class RouteMapper() {
    
    shared {MappedRoute*} map(
            NamingConventions namingConventions,
            Package* controllerPackages) {

        print("Mapping application routes...");
        value pkgs = controllerPackages;
        
        value controllers = LinkedList<ClassDeclaration>();
        for (pkg in pkgs) {
            controllers.addAll(pkg.members<ClassDeclaration>().filter(
                (ClassDeclaration e) => filterControllers(namingConventions, e)));
        }

        value routes = LinkedList<MappedRoute>();
        for (controller in controllers) {
            print("Looking for route trails on ``controller.qualifiedName``...");
            value pkgUri = namingConventions.uriFromPackage(controller.containingPackage);
            value controllerUri = namingConventions.uriFromControllerClass(controller);

            // TODO simple no-arg constructor invoking
            value controllerType = controller.apply<>();
            assert(is Class<Object, []> controllerType);
            value controllerInstance = controllerType();

            value handlers = controller.memberDeclarations<FunctionDeclaration>().filter(
                (FunctionDeclaration elem) => elem.shared);
            for (handler in handlers) {
                value uri = StringBuilder();
                uri.append("/").append(pkgUri).append("/").append(controllerUri).append("/");
                uri.append(namingConventions.uriFromControllerFunction(handler));
                
                value path = namingConventions.normalizeUri(uri.string);
                value mappedRoute = MappedRoute {
                    uriPattern = UriPattern(path);
                    methods = namingConventions.methodsFromControllerFunction(handler);
                    route = annotations(`Route`, handler);
                    controller = controllerInstance;
                    handlerRef = handler;
                };
                
                logRoute(mappedRoute);
                routes.add(mappedRoute);
            }
        }
        return routes.sort(
            (MappedRoute one, MappedRoute other) => one.compare(other)).reversed;
    }

    shared default Boolean filterControllers(NamingConventions namingConventions,
        ClassDeclaration candidate) =>
            candidate.name.endsWith(namingConventions.controllerSuffix);

    void logRoute(MappedRoute mappedRoute) {
        value handlerRef = mappedRoute.handlerRef;
        value routeRep = StringBuilder();

        routeRep.append("  [");
        routeRep.append(",".join(mappedRoute.methods.map(
            (HttpMethod elem) => elem.name.uppercased)));
        routeRep.append("] requests on \"")
                .append(mappedRoute.uriPattern.pattern)
                .append("\" will handled by \"")
                .append(handlerRef.container.name)
                .append(".``handlerRef.name``\"");
        print(routeRep.string);
    }
    
}