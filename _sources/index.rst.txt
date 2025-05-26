******
Base64
******

.. current-library:: base64
.. current-module:: base64

This library implements the Base64 encoding algorithm as defined in `RFC 4648
<https://datatracker.ietf.org/doc/html/rfc4648>`_.

.. toctree::
   :maxdepth: 3
   :hidden:

Usage
=====

Add ``"base64"`` to the dependencies listed in your project's "dylan-package.json" file
and run ``deft update`` to install the base64 package and update your workspace
registry.  Add ``use base64;`` to your library and module definitions.

The ``base64`` library exports two functions:

-  :func:`base64-encode`
-  :func:`base64-decode`

Both of these function accept a ``scheme:`` keyword argument of type :type:`<scheme>`
which may be one of the following constants:

- :const:`$standard-scheme` - the standard base64 character set including ``+`` and
   ``/``.
- :const:`$url-scheme` - a character set safe for use in URLs and filenames, in which
  ``+`` is replaced by ``-`` and ``/`` is replaced by ``_``.

.. note:: There is currently no support for line breaks or whitespace in the
          input/output, nor for base64 streams. Pull requests welcome.


The base64 Module
=================

.. type:: <scheme>

   Equivalent to ``one-of($standard-scheme, $url-scheme)``.

.. constant:: $standard-scheme

   An instance of :type:`<scheme>` indicating to use the `standard base64 encoding
   character set <https://datatracker.ietf.org/doc/html/rfc4648#section-4>`_.

.. constant:: $url-scheme

   An instance of :type:`<scheme>` indicating to use the `URL and filename safe base64
   character set <https://datatracker.ietf.org/doc/html/rfc4648#section-5>`_.

.. function:: base64-encode

   Encode a byte sequence as a base 64 byte string as defined by `RFC 4648
   <https://datatracker.ietf.org/doc/html/rfc4648>`_.

   :signature: base64-encode (bytes, #key scheme, pad?) => (byte-string)
   :parameter bytes: An instance of :drm:`<sequence>`.  An error is signaled if the
      elements of this sequence are not either integers in the range 0 - 255 or byte
      characters.
   :parameter #key scheme: An instance of :type:`<scheme>`.  May be either
      :const:`$standard-scheme` (the default) or :const:`$url-scheme`.
   :parameter #key pad?: An instance of :drm:`<boolean>`. If true (the default) the
      returned byte string is padded with "=" to a multiple of 4 characters in
      length.  This results in 0, 1, or 2 "=" characters at the end of the string.
   :value string: An instance of :drm:`<byte-string>`.

   :example:

      .. code-block:: dylan

        base64-encode("foo") => "Zm9v"
        base64-encode(#(251, 252, 253, 254, 255)) => "+/z9/v8="
        base64-encode(#(251, 252, 253, 254, 255), scheme: $url-scheme) => "-_z9_v8="

.. function:: base64-decode

   Decode a base 64 encoded string into a byte sequence as defined by `RFC 4648
   <https://datatracker.ietf.org/doc/html/rfc4648>`_.

   :signature: base64-decode (string, #key scheme) => (bytes)
   :parameter string: An instance of :drm:`<byte-string>`.
   :parameter #key scheme: An instance of :type:`<scheme>`.  May be either
      :const:`$standard-scheme` (the default) or :const:`$url-scheme`.
   :value bytes: An instance of :class:`<byte-vector>`.
   :example:

   :description:

      Padding characters ("=") at the end of the input string are automatically detected
      and ignored.

   :example:

      .. code-block:: dylan

        base64-decode("Zm8=") => {<simple-byte-vector>: 102, 111}
        base64-decode("Zm8") => {<simple-byte-vector>: 102, 111}
