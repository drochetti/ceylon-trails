import ceylon.net.http {
    Header
}
import ceylon.net.http.server {
    Response
}

import org.vertx.java.core.buffer {
    Buffer
}
import org.vertx.java.core.http {
    HttpServerResponse
}

class ResponseAdapter(HttpServerResponse res) satisfies Response {

    shared actual Integer responseStatus => res.statusCode;
    assign responseStatus {
        res.setStatusCode(responseStatus);
    }

    shared actual void addHeader(Header header) {
        for (headerValue in header.values) {
            res.putHeader(header.name, headerValue);
        }
    }

    shared actual void writeBytes(Array<Integer> bytes) {
        value buffer = Buffer(bytes.size);
        for (b in bytes) {
            buffer.appendByte(b);
        }
        res.write(buffer);
    }

    shared actual void writeString(String string) => res.write(string);
    
}
