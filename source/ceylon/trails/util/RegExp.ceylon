import java.lang {
    JString=String
}
import java.util.regex {
    Pattern {
        compile,
        quote
    },
    Matcher
}

shared String quoteRegExp(String exp) {
    return quote(exp).string;
}

shared class RegExp(String expression) {

    Pattern compiledExpression = compile(expression);

    shared Integer flags() => compiledExpression.flags();

    shared Boolean matches(String input) => matcher(input).matches();

    shared String replace(String input, String replacement) =>
        matcher(input).replaceAll(replacement);

    shared Matcher matcher(String input) =>
        compiledExpression.matcher(JString(input));

    shared actual String string => expression;

}