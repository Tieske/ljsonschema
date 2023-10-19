# CHANGELOG

## Versioning

This library is versioned based on Semantic Versioning ([SemVer](https://semver.org/)).

#### Version scoping

The scope of what is covered by the version number excludes:

- error messages; the text of the messages can change, unless specifically documented.

#### Releasing new versions

- update the changelog below
- check copyright years in `LICENSE.md` and in the module level doc comments in `init.lua`
- create new rockspec; `cp lua-resty-ljsonschema-scm-1.rockspec rockspecs/lua-resty-ljsonschema-X.Y.Z-1.rockspec`
- edit the rockspec to match the new release
- render the documentation; `ldoc .`
- commit changes as `release X.Y.Z`, using `git add rockspecs/ && git commit -a`
- tag the commit; `git tag X.Y.Z`
- push the commit and the tag; `git push && git push --tags`
- upload rockspec; `luarocks upload rockspecs/lua-resty-ljsonschema-X.Y.Z-1.rockspec --api-key=abcdef`

## Version history

### 1.2.0-2 (19-Oct-2023)

 - this rockspec update was lost on 1.2.0 release (see 1.1.6-2 below), applying it again.
   This is not a real release (has no tag), since it doesn't change any code. It only updates
   the rockspec to revert [#23](https://github.com/Tieske/lua-resty-ljsonschema/pull/23).
   See: https://github.com/openresty/lua-cjson/issues/96

### 1.2.0 (23-Oct-2024)

- fix: properly calculate utf8 sequence lengths instead of byte count
  ([#30](https://github.com/Tieske/lua-resty-ljsonschema/pull/30))
- fix: support `null` as an option in `enum` types
  ([#26](https://github.com/Tieske/lua-resty-ljsonschema/pull/26))
- chore: update the test suite to a more recent version; 23.2.0
  ([#27](https://github.com/Tieske/lua-resty-ljsonschema/pull/27))
- chore: list all disabled tests as `pending` (to make them visible)
  ([#27](https://github.com/Tieske/lua-resty-ljsonschema/pull/27))
- fix: fix numeric overflow (new case from updated test-suite)
  ([#27](https://github.com/Tieske/lua-resty-ljsonschema/pull/27))
- chore: restructure documentation and more repo-maintenance
  ([#25](https://github.com/Tieske/lua-resty-ljsonschema/pull/25))

### 1.1.6-2 (19-Oct-2023)

 - this is not a real release (has no tag), since it doesn't change any code. It only updates
   the rockspec to revert [#23](https://github.com/Tieske/lua-resty-ljsonschema/pull/23).
   See: https://github.com/openresty/lua-cjson/issues/96

### 1.1.6 (21-Sep-2023)

- fix: properly check custom.array_mt
  ([#22](https://github.com/Tieske/lua-resty-ljsonschema/pull/22))
- improvement: use openresty table functions if available (`isarray` and `nkeys`)
  ([#22](https://github.com/Tieske/lua-resty-ljsonschema/pull/22))
- fix: add lua-cjson to the rockspec since it is required
  ([#23](https://github.com/Tieske/lua-resty-ljsonschema/pull/23))

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
