import ceylon.net.http {
    Header
}
import ceylon.net.http.server {
    Response
}
import ceylon.trails.http {
    MimeType,
    textPlain
}

shared interface ContentRenderer {

    shared formal Boolean accepts(MimeType* types);

    shared formal Boolean matches(Object result);

    shared default void render(Object result, Response response) {
        setContentType(textPlain, response);
        response.writeString(result.string);
    }

    void setContentType(MimeType type, Response response) {
        response.addHeader(Header("Content-Type", type.string));
    }

}