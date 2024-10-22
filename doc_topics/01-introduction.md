# 1. Introduction

This library provides a [JSON schema draft 4](https://json-schema.org/specification-links#draft-4)
validator for OpenResty and Lua 5.2+.

It has been designed to validate incoming data for HTTP APIs so it is decently
fast: it works by transforming the given schema into a pure Lua function
on-the-fly.

This is an updated version of [ljsonschema](https://github.com/jdesgats/ljsonschema)
by @jdesgats.


## 1.1 Differences with JSONSchema

Due to the nature of the Lua language, the full JSON schema support is
difficult to reach. Some of the limitations can be solved using customizing the
behaviour, but some features are not supported (correctly) at this time:

* Unicode strings are considered as a stream of bytes (so length checks might
  not behave as expected)


## 1.2 Handling JSON

When decoding JSON into a Lua table there are several things that require some
extra attention. The default is to use `lua-cjson` and its implementation of the
values below.

The prefered setup:
```lua
local cjson = require("cjson.safe").new() -- use 'new' to not pollute the global instance
cjson.decode_array_with_array_mt(true) -- force decoded arrays to be marked with `array_mt`
```

## 1.2.1 Null values

Lua doesn't have an explicit `null` value. In JSON `null` essentially means, this
key exists, but it has no value. Whereas the Lua equivalent `nil` cannot distinguish
between the key non existing and the key having no value.

As such a sentinel value must be defined that is unique and can be used to represent
the JSON-null value.


## 1.2.2 Array vs Object

Lua tables are more versatile than the JSON Array and JSON Object types, and hence
a table is used to represent both JSON types. This can however create ambiguity when
validating. When decoding JSON, both an empty array and an empty object will be
decoded to an empty Lua table. So it cannot be properly validated as being either one.

For this purpose a meta-table (`array_mt`) is defined and should be attached to arrays.


## 1.3 Customizing behaviour

Some advanced features of JSON Schema are not possible to implement using the
standard library and require third party libraries to work.

In order to not force one particular library, and not bloat this library for
the simple schemas, extension points are provided. For details see the
`generate_validator` method and its options.


## 1.4 Automatic coercion

When validating properties that are not json, the input usually always is a
string value. For example a query string or header value.

For these cases there is an option `coercion`. If you set this flag then
a string value targetting a type of `boolean`, `number`, or `integer` will be
attempted coerced to the proper type. After which the validation will occur.


## 1.5 Installation

It is aimed at use with `lua-cjson`. Since it uses the cjson
semantics for arrays ([`array_mt`](https://github.com/openresty/lua-cjson#decode_array_with_array_mt))

The preferred way to install this library is to use Luarocks:

    luarocks install lua-resty-ljsonschema

To install it from the repo use the `Makefile`:

    make install


## 1.6 Development

Running the tests requires the Busted test framework. The test suite is based of a
standard test suite for JSONschema and is included as a Git submodule.

To set up the repo for testing use the `Makefile`. To list the available targets do:

    make
