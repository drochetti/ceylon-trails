import ceylon.trails {
    Application
}
import ceylon.trails.engine {
    RequestContext
}

"The base interface for high level and end to end framework
 configuration and customization."
shared interface Middleware { }

shared interface ApplicationMiddleware satisfies Middleware {

    shared formal void apply(Application application);

}

shared interface RequestMiddleware satisfies Middleware {

    shared formal Object? apply(RequestContext context, Object? next());

}