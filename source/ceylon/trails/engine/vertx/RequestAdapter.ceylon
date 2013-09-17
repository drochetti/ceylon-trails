import ceylon.io {
    SocketAddress
}
import ceylon.net.http {
    Method,
    parseMethod
}
import ceylon.net.http.server {
    Request,
    Session
}

import java.lang {
    JString=String
}
import java.util {
    List
}

import org.vertx.java.core.http {
    HttpServerRequest
}

class RequestAdapter(HttpServerRequest req) satisfies Request {
    
    shared actual String? contentType => req.headers().get("Content-Type");

    shared actual String? header(String name) => req.headers().get(name);
    
    shared actual String[] headers(String name) {
        value values = SequenceBuilder<String>();
        List<JString> headers = req.headers().getAll(name);
        for (i in 0..headers.size()) {
            values.append(headers.get(i).string);
        }
        return values.sequence;
    }
    
    shared actual Method method => parseMethod(req.method());
    
    shared actual String? parameter(String name) => req.params().get(name);
    
    shared actual String[] parameters(String name) {
        value values = SequenceBuilder<String>();
        List<JString> params = req.params().getAll(name);
        for (i in 0..params.size()) {
            values.append(params.get(i).string);
        }
        return values.sequence;
    }

    shared actual String path = req.path();

    shared actual String queryString = req.query() else "";

    shared actual String relativePath = req.path(); // TODO ?

    shared actual String scheme = req.absoluteURI().scheme;

    value netSocket = req.netSocket();

    value remoteAddress = netSocket.remoteAddress();
    shared actual SocketAddress sourceAddress = SocketAddress {
        address = remoteAddress.hostString;
        port = remoteAddress.port;
    };

    value localAddress = netSocket.localAddress();
    shared actual SocketAddress destinationAddress = SocketAddress {
        address = localAddress.hostString;
        port = localAddress.port;
    };

    shared actual String uri = req.uri();

    shared actual Session session = SessionAdapter();

}