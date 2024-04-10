# Base64
[![build-and-test](https://github.com/dylan-lang/base64/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/dylan-lang/base64/actions/workflows/build-and-test.yml)

Base64 implementation for Dylan

## Abstract

This library implements the Base64 transfer encoding algorithm as
defined in [RFC 1521](https://datatracker.ietf.org/doc/html/rfc1521)
by Borensten & Freed, September 1993.

# Usage

## Functions exported

This library exports two functions

- `base64-encode (string) => (string)` and

- `base64-decode (string) => (string)`

## Types of encoding

The functions have two types of encoding/decoding:

- `#"standard"` (default) and

- `#"http"`

The main difference between them are the padding characters used. You
can choose the type with the key parameter `encoding:` (see example below).

## Example

### Standard encoding/decoding

Here is an example of usage of the standard encoding/decoding:

```dylan
// Example string to encode
let original-string = "Many hands make light work.";

// Encoding the string to base64 standard
let encoded-standard = base64-encode(original-string);
format-out("Encoded string: %=\n", encoded-standard);

// Shows in output
// Encoded string: "TWFueSBoYW5kcyBtYWtlIGxpZ2h0IHdvcmsu"

// Decoding the string in base64 standard
let decoded-string = base64-decode(encoded-standard);
format-out("Decoded string: %=\n", decoded-string);

// Shows in output
// Decoded string: "Many hands make light work."
```
### HTTP encoding/decoding

To show the http encoding/decoding we will use a text that forces the
padding (base64 encoding uses padding to ensure that the length of the
encoded string is a multiple of 4 bytes).

```dylan
// Example string to encode, note the missing dot at the end
let original-string = "Many hands make light work";

// Encoding the string to base64 http
let encoded-http = base64-encode(original-string, encoding: #"http");
format-out("Encoded string: %=\n", encoded-http);

// Shows in output (note the padding character '@')
// Encoded string: "TWFueSBoYW5kcyBtYWtlIGxpZ2h0IHdvcms@"

// Decoding the string in base64 http
let decoded-string = base64-decode(encoded-http, encoding: #"http");
format-out("Decoded string: %=\n", decoded-string);

// Shows in output
// Decoded string: "Many hands make light work"
```

## Author

Original version written in Common Lisp by Juri Pakaste <juri@iki.fi>.
Converted to Dylan by Carl Gay, July 2002.