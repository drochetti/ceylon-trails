import ceylon.collection {
    HashMap
}
import ceylon.net.uri {
    Uri
}
import ceylon.trails.util {
    RegExp,
    quoteRegExp
}


RegExp uriVariableExp = RegExp("\\{([^/]+?)\\}");

[RegExp, [String*]] parseUriPattern(String uri, String variableExp = "(.*)") {
    value compiled = StringBuilder();
    value matcher = uriVariableExp.matcher(uri);

    String encodeAndQuote(String uri, Integer start, Integer end) {
        if (start == end) {
            return "";
        } else {
            value path = uri.segment(start, end - start);
            // TODO encode?
            //return quoteRegExp(percentEncoder.encodePathSegmentName(path));
            return quoteRegExp(path);
        }
    }
    
    value variables = SequenceBuilder<String>();

    variable value end = 0;
    while (matcher.find()) {
        compiled.append(encodeAndQuote(uri, end, matcher.start()));
        compiled.append(variableExp);
        
        variables.append(matcher.group(1));

        end = matcher.end();
    }
    compiled.append(encodeAndQuote(uri, end, uri.size));
    if (exists last = compiled.string.last, last == "/") {
        compiled.delete(compiled.size - 1, 1);
    }

    return [RegExp(compiled.string), variables.sequence];
}

"Represents a Uri that may contain variables patterns,
 for example: /user/{id}
 This implementation was based on class
 org.springframework.web.util.UriTemplate from SpringMVC."
shared class UriPattern(pattern)
        satisfies Comparable<UriPattern> {
    
    value parsed = parseUriPattern(pattern);
    
    shared String pattern;

    value matchExpression = parsed[0];

    shared String patternMatcher = matchExpression.string;

    shared [String*] variables = parsed[1];

    shared Uri expand(Anything* values) {
        return nothing;
    }

    shared Boolean matches(String uri) => matchExpression.matches(uri);

    shared Map<String, String> match(String uri) {
        value result = HashMap<String, String>();
        value matcher = matchExpression.matcher(uri);
        if (matcher.find()) {
            for (i in 1..matcher.groupCount()) {
                assert (exists name = variables[i - 1]);
                result.put(name, matcher.group(i));
            }
        }
        return result;
    }

    shared Integer variableCount => variables.size;

    shared Integer levels => pattern.count((Character c) => c == '/');

    shared actual Comparison compare(UriPattern other) {
        // TODO implement this better (look at JSR-311 spec)
        variable value result = levels <=> other.levels;
        if (result == equal) {
            result = variableCount <=> other.variableCount;
            if (result == equal) {
                result = patternMatcher.size <=> other.patternMatcher.size;
            }
        }
        return result;
    }

}
