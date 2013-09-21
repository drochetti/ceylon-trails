import ceylon.language.meta {
    annotations
}
import ceylon.language.meta.declaration {
    Package,
    ClassDeclaration,
    FunctionDeclaration
}
import ceylon.trails.http {
    HttpMethod,
    get,
    post,
    put,
    delete
}
import ceylon.trails.util {
    RegExp
}


shared class NamingConventions(
        controllerPackage = "controller",
        controllerSuffix = "Controller") {
    
    //shared String assetsPackage;

    shared String controllerPackage;

    shared String controllerSuffix;

    //shared String modelPackage;

    shared default {<String->Route>*} actionNameConventions = {
        "index" -> Route { path = "/"; through = { get }; },
        "show" -> Route { path = "/{id}"; through = { get }; },
        "edit" -> Route { path = "/{id}/edit"; through = { get }; },
        "editNew" -> Route { path = "/new"; through = { get }; },
        "create" -> Route { path = "/"; through = { post }; },
        "update" -> Route { path = "/{id}"; through = { put }; },
        "destroy" -> Route { path = "/{id}"; through = { delete }; }
    };

    shared String uriFromPackage(Package pkg) {
        value route = annotations(`Route`, pkg);
        if (exists route) {
            return route.path;
        } else {
            value name = pkg.qualifiedName;
            value i = name.firstInclusion(controllerPackage);
            assert(exists i);
            value uri = name.segment(i + controllerPackage.size, name.size);
            return memberNameToUri(uri.replace(".", "/"));
        }
    }

    shared String uriFromControllerClass(ClassDeclaration controllerClass) {
        value route = annotations(`Route`, controllerClass);
        return route?.path
            else memberNameToUri(controllerClass.name.replace(controllerSuffix, ""));
    }

    shared String uriFromControllerFunction(FunctionDeclaration controllerAction) {
        value route = routeFromControllerFunction(controllerAction);
        return route?.path
            else memberNameToUri(controllerAction.name.replace(controllerSuffix, ""));
    }

    shared {HttpMethod*} methodsFromControllerFunction(
            FunctionDeclaration controllerAction) {
        value route = routeFromControllerFunction(controllerAction);
        return route?.through else {get};
    }

    Route? routeFromControllerFunction(FunctionDeclaration controllerAction) {
        variable value route = annotations(`Route`, controllerAction);
        if (!route exists) {
            route = actionNameConventions.find(
                (String->Route elem) => elem.key == controllerAction.name)?.item;
        }
        return route;
    }

    shared String memberNameToUri(String name) {
        value uri = StringBuilder();
        uri.append(name.first?.string?.lowercased else "");
        for (c in name.rest) {
            if (c.uppercase) {
                uri.append("-");
            }
            uri.append(c.lowercased.string);
        }
        return uri.string;
    }

    shared String normalizeUri(String uri) {
        value normUri = RegExp("/{2,}").replace(uri, "/").trimmed;
        if (normUri.size > 1,
                exists last = normUri.last,
                last == '/') {
            return normUri[...normUri.size - 2];
        }
        return normUri;
    }

}