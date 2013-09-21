import ceylon.language.meta.declaration {
    Package,
    ClassOrInterfaceDeclaration,
    FunctionDeclaration
}
import ceylon.trails.http {
    get,
    head,
    HttpMethod
}

shared alias RoutableElements =>
        FunctionDeclaration |
        ClassOrInterfaceDeclaration |
        Package;

shared final annotation class Route(
            path, through)
        satisfies OptionalAnnotation<Route, RoutableElements> {

    shared String path;

    shared {HttpMethod*} through;

}

shared annotation Route route(
        String path = "",
        {HttpMethod*} through = {get, head}) => Route(path, through);
