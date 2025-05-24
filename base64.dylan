Module:    base64
Synopsis:  Base64 encoding/decoding as defined in RFC 4648
License:   This code is in the public domain
Warranty:  Distributed WITHOUT WARRANTY OF ANY KIND


// TODO:
//   * support line breaks
//   * streaming / chunking a la CL's qbase64


define constant $standard-scheme = #"_base64";
define constant $url-scheme      = #"_base64url";
define constant <scheme>         = one-of($standard-scheme, $url-scheme);

define constant $pad-char :: <character> = '=';

// Base 64 Encoding
// https://datatracker.ietf.org/doc/html/rfc4648#section-4
define constant $standard-encoding :: <byte-string>
  = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

// Base 64 Encoding with URL and Filename Safe Alphabet
// https://datatracker.ietf.org/doc/html/rfc4648#section-5
define constant $url-encoding :: <byte-string>
  = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

define constant $standard-decoding :: <byte-vector>
  = make-decoding-vector($standard-encoding);

define constant $url-decoding :: <byte-vector>
  = make-decoding-vector($url-encoding);

define function make-decoding-vector
    (encoding-vector :: <byte-string>) => (v :: <byte-vector>)
  let v = make(<byte-vector>, size: 128);
  for (i from 0,
       char in encoding-vector)
    let code = as(<integer>, char);
    v[code] := i;
  end;
  v
end function;

define inline function encoded-length
    (input-length :: <integer>, pad? :: <boolean>)
 => (encoded-length :: <integer>)
  if (pad?)
    // Four chars for every group of 3 bytes including the final group.
    ceiling/(input-length, 3) * 4
  else
    // One char for every 6 bits in the total bits.
    ceiling/(input-length * 8, 6)
  end
end function;

define inline function decoded-length
    (input :: <byte-string>) => (decoded-length :: <integer>)
  let len = input.size;
  // Discard at most two trailing pad chars from the length.
  if (len - 2 >= 2 & input[len - 2] == $pad-char)
    len := len - 2;
  elseif (len - 1 >= 3 & input[len - 1] == $pad-char)
    len := len - 1
  end;
  floor/(len * 6, 8)
end function;

// Encode `bytes` into base 64 in a <byte-string> using the character set specified by
// `scheme`. If `pad?` is true the returned string will be a multiple of 4 characters in
// length, padded with 0 to 2 '=' characters.
define function base64-encode
    (bytes :: <sequence>,
     #key scheme :: <scheme> = $standard-scheme, pad? :: <boolean> = #t)
 => (string :: <byte-string>)
  let encoding-vector :: <byte-string>
    = select (scheme)
        $standard-scheme => $standard-encoding;
        $url-scheme      => $url-encoding;
      end;
  let convert = if (instance?(bytes, <string>))
                  curry(as, <integer>)
                else
                  identity
                end;
  let nbytes :: <integer> = bytes.size;
  let nchars :: <integer> = encoded-length(nbytes, pad?);
  let result = make(<byte-string>, size: nchars);
  let bi :: <integer> = 0;      // bytes index
  let ri :: <integer> = 0;      // result index
  while (bi < nbytes)
    let b1 :: <byte> = convert(bytes[bi]);
    let b2 :: <byte> = if (bi + 1 < nbytes) convert(bytes[bi + 1]) else 0 end;
    let b3 :: <byte> = if (bi + 2 < nbytes) convert(bytes[bi + 2]) else 0 end;
    let n :: <integer> = ash(b1, 16) + ash(b2, 8) + b3;
    for (shift from -18 to 0 by 6,
         while: ri < nchars)    // can happen for pad?: #f
      let index = logand(ash(n, shift), #b111111);
      result[ri] := encoding-vector[index];
      ri := ri + 1;
    end;
    bi := bi + 3;
  end while;
  if (pad?)
    let len :: <integer> = encoded-length(nbytes, #f);
    for (i from len below nchars)
      result[i] := $pad-char;
    end;
  end;
  result
end function;

define function base64-decode
    (string :: <byte-string>, #key scheme :: <scheme> = $standard-scheme)
 => (bytes :: <byte-vector>)
  let decoding-vector :: <byte-vector>
    = select (scheme)
        $standard-scheme => $standard-decoding;
        $url-scheme      => $url-decoding;
      end;
  let nchars :: <integer> = string.size;
  let nbytes :: <integer> = decoded-length(string);
  let bytes = make(<byte-vector>, size: nbytes);
  let bi :: <integer> = 0;
  let si :: <integer> = 0;
  while (si < nchars)
    let c1 = as(<integer>, string[si]);                si := si + 1;
    let c2 = si < nchars & as(<integer>, string[si]);  si := si + 1;
    let c3 = si < nchars & as(<integer>, string[si]);  si := si + 1;
    let c4 = si < nchars & as(<integer>, string[si]);  si := si + 1;
    let d1 :: <byte> =         decoding-vector[c1];
    let d2 :: <byte> = if (c2) decoding-vector[c2] else 0 end;
    let d3 :: <byte> = if (c3) decoding-vector[c3] else 0 end;
    let d4 :: <byte> = if (c4) decoding-vector[c4] else 0 end;
    let n :: <integer> = ash(d1, 18) + ash(d2, 12) + ash(d3, 6) + d4;
    for (shift from -16 to 0 by 8,
         while: bi < nbytes)
      bytes[bi] := logand(ash(n, shift), #xff);
      bi := bi + 1;
    end;
  end while;
  bytes
end function;

