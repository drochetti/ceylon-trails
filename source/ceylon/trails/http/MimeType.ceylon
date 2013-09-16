
shared object textPlain extends MimeType("text", "plain") {}

shared object textHtml extends MimeType("text", "html") {}

shared class MimeType(type, subtype) {

    shared String type;

    shared String subtype;

    string => "``type``/``subtype``";

}