import ceylon.collection {
    LinkedList
}
import ceylon.language.model {
    type,
    annotations,
    Class
}
import ceylon.language.model.declaration {
    FunctionDeclaration,
    Package,
    ClassDeclaration
}
import ceylon.trails.http {
    HttpMethod
}
import ceylon.trails.uri {
    UriPattern
}

shared class RouteMapper(namingConventions = NamingConventions()) {
    
    shared default NamingConventions namingConventions;
    
    shared {MappedRoute*} map() {

        print("Mapping application routes...");
        value pkgs = findControllersPackage();
        
        value controllers = LinkedList<ClassDeclaration>();
        for (pkg in pkgs) {
            controllers.addAll(pkg.members<ClassDeclaration>().filter(filterControllers));
        }
        
        value routes = LinkedList<MappedRoute>();
        for (controller in controllers) {
            print("Looking route trails on ``controller.qualifiedName``...");
            value pkgUri = namingConventions.uriFromPackage(controller.containingPackage);
            value controllerUri = namingConventions.uriFromControllerClass(controller);

            // TODO simple no-arg constructor invoking
            value controllerType = controller.apply();
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
            (MappedRoute one, MappedRoute other) => one.compare(other));
    }

    shared default Boolean filterControllers(
        ClassDeclaration candidate) => candidate.name.endsWith(namingConventions.controllerSuffix);

    shared default {Package*} findControllersPackage() {
        value appModule = type(this).declaration.containingModule;
        return appModule.members.filter(
            (Package elem) => elem.name.contains(namingConventions.controllerPackage));
    }

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