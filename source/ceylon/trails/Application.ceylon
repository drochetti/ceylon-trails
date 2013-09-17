import ceylon.language.model {
    type
}
import ceylon.language.model.declaration {
    Package
}
import ceylon.trails.engine {
    WebEngine
}
import ceylon.trails.engine.httpd {
    HttpdEngine
}
import ceylon.trails.routing {
    RouteMapper,
    NamingConventions
}
import ceylon.trails.core.render { ContentRendererMiddleware, HtmlRenderer }
import ceylon.trails.core { RequestMiddleware, ApplicationMiddleware, PoweredByMiddleware, HttpMethodOverrideMiddleware }
import ceylon.collection { LinkedList }

{RequestMiddleware+} defaultRequestMiddlewares = {
    PoweredByMiddleware(),
    HttpMethodOverrideMiddleware(),
    ContentRendererMiddleware(HtmlRenderer())
};

shared abstract class Application(engine = HttpdEngine()) {

    shared default String name =>
        type(this).declaration.containingModule.name;

    shared default String version =>
        type(this).declaration.containingModule.version;

    shared default NamingConventions namingConventions => NamingConventions();

    shared default RouteMapper routeMapper => RouteMapper();

    shared WebEngine engine;

    value appMiddlewares => LinkedList<ApplicationMiddleware>();

    shared void setup(ApplicationMiddleware* middleware) {
        appMiddlewares.addAll(middleware);
    }


    value requestMiddlewares => LinkedList<RequestMiddleware>(defaultRequestMiddlewares);

    shared void use(RequestMiddleware* middleware) {
        requestMiddlewares.addAll(middleware);
    }

    shared default void start() {
        print("Starting application ``name`` ``version``");
        print("Using ``engine.name`` engine: ``type(engine).declaration.qualifiedName``");
        
        value routes = routeMapper.map(namingConventions,
            *findControllersPackages());
        engine.bindRoutes(*routes);
        engine.bindRequestMiddlewares(*requestMiddlewares);
        engine.start();
        
        // TODO figure out how to do it right
        print(process.newline);
        print("Press 'q' to stop the server...");
        value cmd = process.readLine();
        print("cmd");
        if (cmd.size > 1, cmd.lowercased == 'q') {
            engine.stop();
        }
    }

    shared default {Package*} findControllersPackages() {
        value appModule = type(this).declaration.containingModule;
        return appModule.members.filter(
            (Package elem) =>
                elem.name.contains(namingConventions.controllerPackage)
        );
    }

}