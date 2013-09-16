import ceylon.language.model {
    type
}
import ceylon.trails.engine {
    WebEngine
}
import ceylon.trails.routing {
    RouteMapper, NamingConventions
}

shared class Application(
        engine,
        namingConventions = NamingConventions(),
        routeMapper = RouteMapper()) {


    shared default String name =>
        type(this).declaration.containingModule.name;

    shared default String version =>
        type(this).declaration.containingModule.version;

    shared NamingConventions namingConventions;

    shared WebEngine engine;

    shared RouteMapper routeMapper;
    
    shared default void start() {
        print("Starting application ``name`` ``version``");
        print("Using ``engine.name`` engine: ``type(engine).declaration.qualifiedName``");
        
        value routes = routeMapper.map();
        engine.bindRoutes(*routes);
        engine.start();
        
        print(process.newline);
        print("Press 'q' to stop the server...");
        value cmd = process.readLine();
        print("cmd");
        if (cmd.size > 1, cmd.lowercased == 'q') {
            engine.stop();
        }
    }

}