
shared object ok extends HttpStatus(200, "OK") {}

shared object created extends HttpStatus(201, "Created") {}

shared object notModified extends HttpStatus(304, "Not Modified") {}

shared object forbidden extends HttpStatus(403, "Forbidden") {}

shared object notFound extends HttpStatus(404, "Not Found") {}

shared abstract class HttpStatus(code, name)
        of ok | created
        | notModified
        | forbidden | notFound {

    shared Integer code;

    shared String name;

}
