# Prints the name of every method in the given files that isn't a test but whose body asserts: a helper a test can
# call instead of asserting itself. Run with: find <test folders> -name '*.java' | xargs awk -f <this file> | sort -u
/@(Test|ParameterizedTest|RepeatedTest|TestFactory)([^A-Za-z]|$)/ { test = 1 }
!inbody && /^[ \t]*(public|protected|private|static|final|synchronized|[ \t])*[A-Za-z0-9_<>\[\], ]+ [A-Za-z0-9_]+ *\([^;]*$/ && !/^[ \t]*(return|new|if|for|while|switch|catch|else)[ (]/ {
  match($0, /[A-Za-z0-9_]+ *\(/); name = substr($0, RSTART, RLENGTH); sub(/ *\($/, "", name)
  body = ""; depth = 0; open = 0; inbody = 1; istest = test; test = 0
}
inbody {
  body = body $0 "\n"; o = gsub(/\{/, "{"); c = gsub(/\}/, "}"); depth += o - c; if (o) open = 1
  if (open && depth <= 0) {
    if (!istest && body ~ /assert[A-Z(]|assertThat|verify\(|fail\(|assertThrows/) print name
    inbody = 0
  }
}
