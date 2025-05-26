Module:    dylan-user
Synopsis:  Base64 encoding/decoding as defined in RFC 4648
License:   This code is in the public domain
Warranty:  Distributed WITHOUT WARRANTY OF ANY KIND

define library base64
  use common-dylan;

  export base64;
end library;

define module base64
  use byte-vector;
  use common-dylan;

  export
    base64-encode,
    base64-decode,
    <scheme>,
    $standard-scheme,
    $url-scheme;
end module;
