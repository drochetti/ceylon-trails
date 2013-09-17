import ceylon.language.model {
    type
}
import ceylon.net.http {
    Header
}
import ceylon.trails.engine {
    RequestContext
}

shared class PoweredByMiddleware() satisfies RequestMiddleware {

    shared actual Object? apply(RequestContext context, Object? next()) {
        value mod = type(this).declaration.containingModule;
        context.response.addHeader(Header("X-Powered-By", "``mod.name`` ``mod.version``"));
        return next();
    }

}

shared class HttpMethodOverrideMiddleware() satisfies RequestMiddleware {

    shared actual Object? apply(RequestContext context, Object? next()) {
        return next();
    }

}