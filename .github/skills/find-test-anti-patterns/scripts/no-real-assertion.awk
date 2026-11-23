# Prints path:line for every JUnit test whose body (an empty one included) has no assertion at all.
# Run with: find <test folders> -name '*.java' | sort | xargs awk -f <this file>
/@(Test|ParameterizedTest|RepeatedTest|TestFactory)([^A-Za-z]|$)/ { ann = ann $0; want = 1 }
want && /void [A-Za-z0-9_]+\(/ { line = FNR; body = ""; depth = 0; open = 0; inbody = 1; want = 0 }
inbody {
  body = body $0 "\n"; o = gsub(/\{/, "{"); c = gsub(/\}/, "}"); depth += o - c; if (o) open = 1
  if (open && depth <= 0) {
    if (body ann !~ /assert[A-Z(]|assertThat|verify\(|fail\(|assertThrows|expected *=|ExpectedException/) print FILENAME ":" line
    inbody = 0; ann = ""
  }
}
