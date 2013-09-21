import ceylon.language.meta { type }

shared object connect extends HttpMethod() {}

shared object delete extends HttpMethod() {}

shared object head extends HttpMethod() {}

shared object get extends HttpMethod() {}

shared object options extends HttpMethod() {}

shared object post extends HttpMethod() {}

shared object put extends HttpMethod() {}

shared object trace extends HttpMethod() {}

shared abstract class HttpMethod()
        of delete | get
        | head | options
        | post | put
        | connect | trace {

    shared String name => type(this).declaration.name;

    string => name.uppercased;

}
