[![OpenResty](https://img.shields.io/github/actions/workflow/status/Tieske/lua-resty-ljsonschema/openresty.yml?branch=master&label=OpenResty&logo=linux)](https://github.com/Tieske/lua-resty-ljsonschema/actions)
[![Lua](https://img.shields.io/github/actions/workflow/status/Tieske/lua-resty-ljsonschema/lua.yml?branch=master&label=Lua&logo=Lua)](https://github.com/Tieske/lua-resty-ljsonschema/actions)
[![Luacheck](https://img.shields.io/github/actions/workflow/status/Tieske/lua-resty-ljsonschema/luacheck.yml?label=Linter&logo=Lua)](https://github.com/Tieske/lua-resty-ljsonschema/actions?workflow=Luacheck)
[![SemVer](https://img.shields.io/github/v/tag/Tieske/lua-resty-ljsonschema?color=brightgreen&label=SemVer&logo=semver&sort=semver)](#history)
[![Licence](http://img.shields.io/badge/Licence-MIT-brightgreen.svg)](LICENSE)


ljsonschema: JSON schema validator
==================================

This library provides a JSON schema draft 4 validator for OpenResty and Lua 5.2+.

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
    luarocks install lua-cjson  # not required when using Openresty, since it comes bundled
    luarocks install busted
    busted


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
local my_validator = jsonschema.generate_validator(my_schema)

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

### Semantic validation with "format" attribute

The "format" keyword is defined to allow interoperable semantic validation for
a fixed subset of values. Currently only `date`, `date-time`, and `time`
attributes are defined and follow RFC 3339 specifications. Validation rules
[5.6][rfc3339-5.6] and the additional restriction rules [5.7][rfc3339-5.7] have
been implemented. All other format attributes will not perform validation.

```lua
local jsonschema = require 'resty.ljsonschema'

local my_schema = {
  type = 'object',
  properties = {
    foo = { type = 'string', format = 'date' },
    bar = { type = 'string', format = 'date-time' },
    baz = { type = 'string', format = 'time' },
  },
}

-- Test our schema to be a valid JSONschema draft 4 spec, against
-- the meta schema:
assert(jsonschema.jsonschema_validator(my_schema))

-- Note: do cache the result of schema compilation as this is a quite
-- expensive process
local my_validator = jsonschema.generate_validator(my_schema)

-- Now validate some data against our spec:
local my_data = {
  foo='2020-02-29',
  bar='2020-02-29T08:30:00Z',
  baz='08:30:60Z'
}
print(my_validator(my_data))   --> true
my_data = {
  foo='20200-02-29',           --> Invalid date specified
  bar='2020-02-29T08:30:00Z',
  baz='08:30:06.283185+00:20'
}
print(my_validator(my_data))   --> false
```

**Note**: Leap seconds cannot be predicted far into the future and are
          therefore allowed for every value validated against "time".

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

    -- There are cases where incoming data will always be strings. For example
    -- when validating http-headers or query arguments.
    -- For these cases there is an option `coercion`. If you set this flag then
    -- a string value targetting a type of `boolean`, `number`, or `integer` will be
    -- attempted coerced to the proper type. After which the validation will occur.
    coercion = false,

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

Versioning
----------

This library is versioned based on Semantic Versioning ([SemVer](https://semver.org/)).
The scope of what is covered by the version number excludes:
- error messages; the text of the messages can change, unless specifically documented.

History
-------

For version behaviour and scoping see [Versioning](#versioning).

#### releasing new versions
- update the changelog below
- check copyright years in `LICENSE`
- create new rockspec; `cp lua-resty-ljsonschema-scm-1.rockspec rockspecs/lua-resty-ljsonschema-X.Y.Z-1.rockspec`
- edit the rockspec to match the new release
- commit changes as `release X.Y.Z`, using `git add rockspecs/ && git commit -a`
- tag the commit; `git tag X.Y.Z`
- push the commit and the tag; `git push && git push --tags`
- upload rockspec; `luarocks upload rockspecs/lua-resty-ljsonschema-X.Y.Z-1.rockspec --api-key=abcdef`

### 1.1.5 (27-Jun-2023)
- fix: using default Lua `tostring` on numbers when generating code can loose
  precision. Implemented a non-lossy function.
  ([#21](https://github.com/Tieske/lua-resty-ljsonschema/pull/21))

### 1.1.4 (25-Apr-2023)
- fix: typo in error message
  ([#16](https://github.com/Tieske/lua-resty-ljsonschema/pull/16))
- fix: update reported types in error messages (eg. 'userdata' instead of 'null')
  ([#17](https://github.com/Tieske/lua-resty-ljsonschema/pull/17))
- ci: switch CI to Github Actions
  ([#18](https://github.com/Tieske/lua-resty-ljsonschema/pull/18))
- ci: add plain Lua to the version matrix
  ([#19](https://github.com/Tieske/lua-resty-ljsonschema/pull/19))

### 1.1.3 (8-Dec-2022)
- fix: reference properties can start with an "_"
  ([#15](https://github.com/Tieske/lua-resty-ljsonschema/pull/15))

### 1.1.2 (30-Apr-2021)
- fix: fixes an issue where properties called "id" were mistaken for schema ids
  ([#13](https://github.com/Tieske/lua-resty-ljsonschema/pull/13))

### 1.1.1 (28-Oct-2020)
- fix: fixes an error in the `maxItems` error message
  ([#7](https://github.com/Tieske/lua-resty-ljsonschema/pull/7))
- fix: date-time validation would error out on bad input
  ([#10](https://github.com/Tieske/lua-resty-ljsonschema/pull/10))
- improvement: anyOf failures now list what failed
  ([#9](https://github.com/Tieske/lua-resty-ljsonschema/pull/9))

### 1.1.0 (18-aug-2020)
- fix: if a `schema.pattern` clause contained a `%` then the generated code
  for error messages (invoking `string.format`) would fail because it tried
  to substitute it (assuming it to be a format specifier). `%` is now properly
  escaped.
- feat: add `date`, `date-time`, and `time` Semantic validation for "format"
  attribute. Validation follows the RFC3339 specification sections
  [5.6][rfc3339-5.6] and [5.7][rfc3339-5.7] for dates and times.

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
- fix: deal with broken coroutine override in OpenResty (by @jdesgats)
- move array/object validation over to OpenResty based CJSON implementation
  (using the `array_mt`)
- fix: schema with only 'required' was not validated at all
- updated testsuite to use Busted
- fix: quoting/escaping

### 7-Jun-2019 Forked from https://github.com/jdesgats/ljsonschema

[rfc3339-5.6]: https://tools.ietf.org/html/rfc3339#section-5.6
[rfc3339-5.7]: https://tools.ietf.org/html/rfc3339#section-5.7
