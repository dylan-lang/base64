Module: base64-test-suite


// Test inputs of different kinds of sequences.
define test test-base64-encode/sequence-types ()
  let one-to-eight = #[1, 2, 3, 4, 5, 6, 7, 8];
  assert-equal("AQIDBAUGBwg=", base64-encode(one-to-eight));
  assert-equal("AQIDBAUGBwg=", base64-encode(as(<byte-vector>, one-to-eight)));
  assert-equal("AQIDBAUGBwg=", base64-encode(map-as(<string>, curry(as, <character>), one-to-eight)));
end test;

define test test-base64-basics ()
  let one-to-eight = #[1, 2, 3, 4, 5, 6, 7, 8];
  assert-equal(one-to-eight, base64-decode("AQIDBAUGBwg="), "decode with padding");
  assert-equal(one-to-eight, base64-decode("AQIDBAUGBwg"), "decode without padding");

  // This test was mainly for a simple, early test during development.
  // "Dylan" = #[68, 121, 108, 97, 110]
  assert-equal("RHlsYW4=", base64-encode("Dylan"));
  assert-equal("RHlsYW4", base64-encode("Dylan", pad?: #f));
  assert-equal("Dylan", as(<string>, base64-decode("RHlsYW4=")));
  assert-equal("Dylan", as(<string>, base64-decode("RHlsYW4")));
end test;

define test test-base64-schemes ()
  assert-equal("YWJjMTI_Z2hp", base64-encode("abc12?ghi", scheme: $url-scheme));
  assert-equal("YWJjMTI/Z2hp", base64-encode("abc12?ghi", scheme: $standard-scheme));

  assert-equal("abc12?ghi", as(<string>, base64-decode("YWJjMTI_Z2hp", scheme: $url-scheme)));
  assert-equal("abc12?ghi", as(<string>, base64-decode("YWJjMTI/Z2hp", scheme: $standard-scheme)));

  assert-equal("PD1jbGFzcz0-", base64-encode("<=class=>", scheme: $url-scheme));
  assert-equal("PD1jbGFzcz0+", base64-encode("<=class=>", scheme: $standard-scheme));

  assert-equal("<=class=>", as(<string>, base64-decode("PD1jbGFzcz0-", scheme: $url-scheme)));
  assert-equal("<=class=>", as(<string>, base64-decode("PD1jbGFzcz0+", scheme: $standard-scheme)));

  // Some /dev/random data that was put through the base64 command.
  let bytes
    = #[220, 250,  30, 104,  61, 250, 170, 204,  63,   8, 159,  45, 241, 117, 122, 122,
        175,  73, 155, 110, 131, 205, 254,  25,  91, 110,  56,  37,  15, 153,  63, 157,
        184, 164,  61, 128, 177,  83,  12,  42, 156, 111,  32, 171,  69, 118,  98,  79,
        104,  35, 174, 115, 211, 146, 152, 211, 113,  62,  31, 159, 120,   0, 229, 192,
        155, 152, 218, 229,  78,  24,  65,  20, 144,   2, 144,  10];
  assert-equal("3PoeaD36qsw_CJ8t8XV6eq9Jm26Dzf4ZW244JQ-ZP524pD2AsVMMKpxvIKtFdmJPaCOuc9OSmNNxPh-feADlwJuY2uVOGEEUkAKQCg==",
               base64-encode(bytes, scheme: $url-scheme));
  assert-equal("3PoeaD36qsw/CJ8t8XV6eq9Jm26Dzf4ZW244JQ+ZP524pD2AsVMMKpxvIKtFdmJPaCOuc9OSmNNxPh+feADlwJuY2uVOGEEUkAKQCg==",
               base64-encode(bytes, scheme: $standard-scheme));

  // Example from qbase64/README.md
  assert-equal("+/z9/v8=", base64-encode(#(251, 252, 253, 254, 255),
                                        scheme: $standard-scheme));
  assert-equal("-_z9_v8=", base64-encode(#(251, 252, 253, 254, 255),
                                        scheme: $url-scheme));
end test;

define test test-base64-encode/empty-sequence ()
  assert-equal("", base64-encode(#[]));
end test;

define test test-base64-decode/empty-string ()
  assert-equal(#[], base64-decode(""));
end test;

define test test-base64-rfc-4648-examples ()
  for (item in #(#("", ""),
                 #("f", "Zg=="),
                 #("fo", "Zm8="),
                 #("foo", "Zm9v"),
                 #("foob", "Zm9vYg=="),
                 #("fooba", "Zm9vYmE="),
                 #("foobar", "Zm9vYmFy")))
    let (decoded, encoded) = apply(values, item);
    assert-equal(encoded, base64-encode(decoded), "base64-encode(%=) => %=", decoded, encoded);
    let string = as(<string>, base64-decode(encoded));
    assert-equal(decoded, string, "base64-decode(%=) => %=", encoded, decoded);
  end;
end test;

run-test-application()
