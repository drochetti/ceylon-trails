import ceylon.trails.core {
    RequestMiddleware
}
import ceylon.trails.engine {
    RequestContext
}
import ceylon.trails.http {
    textHtml
}

shared class ContentRendererMiddleware(ContentRenderer+ renderers)
        satisfies RequestMiddleware {

    shared actual Object? apply(RequestContext context, Object? next()) {
        //value req = context.request;
        //value contentType = req.contentType else textHtml;
        value contentType = textHtml;

        value result = next();
        
        if (exists result) {
            value renderer = renderers.find((ContentRenderer elem)
                    => elem.accepts(contentType) && elem.matches(result));
            assert (exists renderer);
            renderer.render(result, context.response);
        } else {
            // TODO 404?
        }

        return result;
    }

}