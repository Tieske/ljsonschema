[![OpenResty](https://img.shields.io/github/actions/workflow/status/Tieske/lua-resty-ljsonschema/openresty.yml?branch=master&label=OpenResty&logo=linux)](https://github.com/Tieske/lua-resty-ljsonschema/actions)
[![Lua](https://img.shields.io/github/actions/workflow/status/Tieske/lua-resty-ljsonschema/lua.yml?branch=master&label=Lua&logo=Lua)](https://github.com/Tieske/lua-resty-ljsonschema/actions)
[![Luacheck](https://img.shields.io/github/actions/workflow/status/Tieske/lua-resty-ljsonschema/luacheck.yml?label=Linter&logo=Lua)](https://github.com/Tieske/lua-resty-ljsonschema/actions?workflow=Luacheck)
[![SemVer](https://img.shields.io/github/v/tag/Tieske/lua-resty-ljsonschema?color=brightgreen&label=SemVer&logo=semver&sort=semver)](CHANGELOG.md)
[![Licence](http://img.shields.io/badge/Licence-MIT-brightgreen.svg)](LICENSE.md)

# lua-resty-ljsonschema

This library provides a JSON schema draft 4 validator for OpenResty and Lua 5.2+.

It has been designed to validate incoming data for HTTP APIs so it is decently
fast: it works by transforming the given schema into a pure Lua function
on-the-fly.

This is an updated version of [ljsonschema](https://github.com/jdesgats/ljsonschema)
by @jdesgats.


## License and copyright

See [LICENSE.md](LICENSE.md)

## Documentation

See [online documentation](https://tieske.github.io/lua-resty-ljsonschema/)

## Changelog

See [CHANGELOG.md](CHANGELOG.md)
