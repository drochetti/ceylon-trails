import ceylon.html {
    Html
}
import ceylon.html.layout {
    Layout
}
import ceylon.html.serializer {
    HtmlSerializer
}
import ceylon.net.http.server {
    Response
}
import ceylon.trails.core {
    View
}
import ceylon.trails.http {
    MimeType,
    textHtml
}
import ceylon.net.http { Header }

shared class HtmlRenderer() satisfies ContentRenderer {

    shared actual Boolean accepts(MimeType* types)
        => types.any((MimeType e) => e == textHtml);
    
    shared actual Boolean matches(Object result) => true;
    
    //class ResponseSerializer(Html html, Response res)
    //        extends HtmlSerializer(html) {
    //    print(String string) => res.writeString(string);
    //}
    class StringSerializer(Html html, StringBuilder builder)
            extends HtmlSerializer(html) {
        print(String string) => builder.append(string);
    }
    
    shared actual void render(Object result, Response response) {
        variable Html|Layout? html = null;
        if (is Html|Layout result) {
            html = result;
        } else if (is View result) {
            html = result.render();
        }

        // TODO improve this, maybe by changing type hierarchy on Html, Layout stuff
        variable Html? htmlToRender = null;
        if (exists h = html, is Layout h) {
            htmlToRender = h.html;
        } else if (exists h = html, is Html h) {
            htmlToRender = h;
        }
        assert (exists hr = htmlToRender);

        value builder = StringBuilder();
        value serializer = StringSerializer(hr, builder);
        serializer.serialize();
        response.addHeader(Header("Content-Length",
            serializer.contentLength.string));
        response.addHeader(Header("Content-Type",
            "``textHtml.string``; charset=utf-8"));
        response.writeString(builder.string);
    }

}
