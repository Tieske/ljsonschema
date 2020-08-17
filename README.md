ljsonschema: JSON schema validator
==================================

This library provides a JSON schema draft 4 validator for OpenResty.

It has been designed to validate incoming data for HTTP APIs so it is decently
fast: it works by transforming the given schema into a pure Lua function
on-the-fly.

This is an updated version of [ljsonschema](https://github.com/jdesgats/ljsonschema)
by @jdesgats.

Installation
------------

It is aimed at use with Openresty. Since it uses the Openresty cjson
semantics for arrays ([`array_mt`](https://github.com/openresty/lua-cjson#decode_array_with_array_mt))

The preferred way to install this library is to use Luarocks:

    luarocks install lua-resty-ljsonschema

Running the tests also requires the Busted test framework:

    git submodule update --init --recursive
    luarocks install net-url
    luarocks install busted
    ./rbusted -v -o gtest


Usage
-----

### Getting started

```lua
local jsonschema = require 'resty.ljsonschema'

local my_schema = {
  type = 'object',
  properties = {
    foo = { type = 'string' },
    bar = { type = 'number' },
  },
}

-- Test our schema to be a valid JSONschema draft 4 spec, against
-- the meta schema:
assert(jsonschema.jsonschema_validator(my_schema))

-- Note: do cache the result of schema compilation as this is a quite
-- expensive process
local my_validator = jsonschema.generate_validator(my_schema, options)

-- Now validate some data against our spec:
local my_data = { foo='hello', bar=42 }
print(my_validator(my_data))
```

#### Note:

To validate arrays and objects properly, it is required to set the `array_mt`
metatable on array tables. This can be easily achieved by calling
`cjson.decode_array_with_array_mt(true)` before calling `cjson.decode(data)`.

Besides proper validation of objects and arrays, it is also important for
performance. Without the meta table, the library will traverse the entire
table in a non-JITable way.

### Automatic coercion of numbers, integers and booleans

When validating properties that are not json, the input usually always is a
string value. For example a query string or header value.

For these cases there is an option `coercion`. If you set this flag then
a string value targetting a type of `boolean`, `number`, or `integer` will be
attempted coerced to the proper type. After which the validation will occur.

```lua
local jsonschema = require 'resty.ljsonschema'

local my_schema = {
  type = 'object',
  properties = {
    foo = { type = 'boolean' },
    bar = { type = 'number' },
  },
}

local options = {
  coercion = true,
}
-- Note: do cache the result of schema compilation as this is a quite
-- expensive process
local validator          = jsonschema.generate_validator(my_schema)
local coercing_validator = jsonschema.generate_validator(my_schema, options)

-- Now validate string values against our spec:
local my_data = { foo='true', bar='42' }
print(validator(my_data))            -->   false
print(coercing_validator(my_data))   -->   true
```

### Advanced usage

Some advanced features of JSON Schema are not possible to implement using the
standard library and require third party libraries to be work.

In order to not force one particular library, and not bloat this library for
the simple schemas, extension points are provided: the `generate_validator`
takes a second table argument that can be used to customise the generated
parser.

```lua
local v = jsonschema.generate_validator(schema, {
    -- a value used to check null elements in the validated documents
    -- defaults to `cjson.null` (if available) or `nil`
    null = null_token,

    -- a metatable used for tagging arrays. Defaults to cjson.array_mt.
    -- This is required to distinguish objects from arrays in Lua (since
    -- they both are tables). To fall-back on Lua detection of table contents
    -- set the value to a boolean `false`.
    array_mt = metatable_to_tag_arrays,

    -- function called to match patterns, defaults to ngx.re.find.
    -- The JSON schema specification mentions that the validator should obey
    -- the ECMA-262 specification but Lua pattern matching library is much more
    -- primitive than that. Users might want to use PCRE or other more powerful
    -- libraries here
    match_pattern = function(string, patt)
        return ... -- boolean value
    end,

    -- function called to resolve external schemas. It is called with the full
    -- url to fetch (without the fragment part) and must return the
    -- corresponding schema as a Lua table.
    -- There is no default implementation: this function must be provided if
    -- resolving external schemas is required.
    external_resolver = function(url)
        return ... -- Lua table
    end,

    -- name when generating the validator function, it might ease debugging as
    -- as it will appear in stack traces.
    name = "myschema",
})
```

Differences with JSONSchema
---------------------------

Due to the nature of the Lua language, the full JSON schema support is
difficult to reach. Some of the limitations can be solved using the advanced
options detailed previously, but some features are not supported (correctly)
at this time:

* Unicode strings are considered as a stream of bytes (so length checks might
  not behave as expected)

History
-------

### 1.0.x (unreleased)
 - fix: if a `schema.pattern` clause contained a `%` then the generated code
   for error mesages (invoking `string.format`) would fail because it tried
   to substitute it (assuming it to be a format specifier). `%` is now properly 
   escaped.

### 1.0 (15-may-2020)

 - fix: using a string-key containing only numbers would fail because it was
   automatically converted to a number while looking up references.

### 0.3 (18-dec-2019)

 - fix: use a table instead of local variables to work around the limitation of
   a maximum of 200 local variables, which is being hit with complex schemas.

### 0.2 (21-jul-2019)

 - feat: added automatic coercion option
 - refactor: remove all coroutine calls (by @davidor)
 - feat: add function to validate schemas against the jsonschema meta-schema
 
### 0.1 (13-jun-2019)

 - fix: use PCRE regex if available instead of Lua patterns (better jsonschema
   compliance)
 - fix: deal with broekn coroutine override in OpenResty (by @jdesgats)
 - move array/object validation over to OpenResty based CJSON implementation
   (using the `array_mt`)
 - fix: schema with only 'required' was not validated at all
 - updated testsuite to use Busted
 - fix: quoting/escaping

### 7-Jun-2019 Forked from https://github.com/jdesgats/ljsonschema 