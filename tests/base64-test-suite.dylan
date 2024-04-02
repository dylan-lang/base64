Module: base64-test-suite

define constant $text-samples
  = #["Many hands make light work.",
      "Many hands make light work"];

define constant $encoded-standard-samples
  = #["TWFueSBoYW5kcyBtYWtlIGxpZ2h0IHdvcmsu",
      "TWFueSBoYW5kcyBtYWtlIGxpZ2h0IHdvcms="];

define constant $encoded-http-samples
  = #["TWFueSBoYW5kcyBtYWtlIGxpZ2h0IHdvcmsu",
      "TWFueSBoYW5kcyBtYWtlIGxpZ2h0IHdvcms@"];

define test test-base64-standard ()
  for (text in $text-samples, encoded in $encoded-standard-samples)
    assert-equal(encoded, base64-encode(text));
    assert-equal(text, base64-decode(encoded))
  end
end;

define test test-base64-http ()
  for (text in $text-samples, encoded in $encoded-http-samples)
    assert-equal(encoded, base64-encode(text, encoding: #"http"));
    assert-equal(text, base64-decode(encoded, encoding: #"http"))
  end
end;

// Use `_build/bin/base64-test-suite --help` to see options.
run-test-application()
