local package_name = "lua-resty-ljsonschema"
local package_version = "1.1.6"
local rockspec_revision = "2"
local github_account_name = "Tieske"
local github_repo_name = package_name
local git_checkout = package_version == "scm" and "master" or package_version


package = package_name
version = package_version .. "-" .. rockspec_revision

source = {
   url = "git://github.com/"..github_account_name.."/"..github_repo_name..".git",
   branch = git_checkout
}

description = {
   summary = "JSON Schema data validator",
   detailed = [[
      This module is a data validator that implements JSON Schema draft 4.
      Given a JSON schema, it will generate a validator function that can be used
      to validate any kind of data (not limited to JSON).
   ]],
   homepage = "https://github.com/"..github_account_name.."/"..github_repo_name,
   license = "MIT/X11"
}

dependencies = {
   "lua >= 5.1",
   "net-url",
   -- "lua-cjson", disabled, see https://github.com/openresty/lua-cjson/issues/96
}

build = {
   type = "builtin",
   modules = {
      ["resty.ljsonschema.init"] = "src/resty/ljsonschema/init.lua",
      ["resty.ljsonschema.store"] = "src/resty/ljsonschema/store.lua",
      ["resty.ljsonschema.metaschema"] = "src/resty/ljsonschema/metaschema.lua",
   }
}
