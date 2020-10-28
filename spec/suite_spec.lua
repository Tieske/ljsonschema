-- this test uses the official JSON schema test suite:
-- https://github.com/json-schema-org/JSON-Schema-Test-Suite

local json = require 'cjson'
json.decode_array_with_array_mt(true)
local jsonschema = require 'resty.ljsonschema'

-- the full support of JSON schema in Lua is difficult to achieve in some cases
-- so some tests from the official test suite fail, skip them.
local blacklist do
  blacklist = {
    -- edge cases, not supported features
    ['minLength validation'] = {
      ['one supplementary Unicode code point is not long enough'] = true, -- unicode handling
    },
    ['maxLength validation'] = {
      ['two supplementary Unicode code points is long enough'] = true, -- unicode handling
    },
  }

  if not ngx then
    -- additional blacklisted for Lua/LuaJIT specifically
    blacklist['regexes are not anchored by default and are case sensitive'] = {
      ['recognized members are accounted for'] = true -- regex pattern not supported by plain Lua string.find
    }
  end
end


local supported = {
  'spec/extra/sanity.json',
  'spec/extra/empty.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/type.json',
  -- objects
  'spec/JSON-Schema-Test-Suite/tests/draft4/properties.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/required.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/additionalProperties.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/patternProperties.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/minProperties.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/maxProperties.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/dependencies.json',
  'spec/extra/dependencies.json',
  -- strings
  'spec/JSON-Schema-Test-Suite/tests/draft4/minLength.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/maxLength.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/pattern.json',
  -- numbers
  'spec/JSON-Schema-Test-Suite/tests/draft4/multipleOf.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/minimum.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/maximum.json',
  -- lists
  'spec/JSON-Schema-Test-Suite/tests/draft4/items.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/additionalItems.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/minItems.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/maxItems.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/uniqueItems.json',
  -- misc
  'spec/JSON-Schema-Test-Suite/tests/draft4/enum.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/default.json',
  -- compound
  'spec/JSON-Schema-Test-Suite/tests/draft4/allOf.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/anyOf.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/oneOf.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/not.json',
  -- links/refs
  'spec/JSON-Schema-Test-Suite/tests/draft4/ref.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/refRemote.json',
  'spec/JSON-Schema-Test-Suite/tests/draft4/definitions.json',
  'spec/extra/ref.json',
  -- format
  'spec/extra/format/date.json',
  'spec/extra/format/date-time.json',
  'spec/extra/format/time.json',
  'spec/extra/format/unknown.json',
  -- errors
  'spec/extra/errors/anyOf.json',
  -- Lua extensions
  'spec/extra/table.json',
  'spec/extra/function.lua',
}

local function readjson(path)
  if path:match('%.json$') then
    local f = assert(io.open(path))
    local body = json.decode((assert(f:read('*a'))))
    f:close()
    return body
  elseif path:match('%.lua$') then
    return dofile(path)
  end
  error('cannot read ' .. path)
end

local external_schemas = {
  ['http://json-schema.org/draft-04/schema'] = require('resty.ljsonschema.metaschema'),
  ['http://localhost:1234/integer.json'] = readjson('spec/JSON-Schema-Test-Suite/remotes/integer.json'),
  ['http://localhost:1234/subSchemas.json'] = readjson('spec/JSON-Schema-Test-Suite/remotes/subSchemas.json'),
  ['http://localhost:1234/folder/folderInteger.json'] = readjson('spec/JSON-Schema-Test-Suite/remotes/folder/folderInteger.json'),
  ['http://localhost:1234/name.json'] = readjson('spec/JSON-Schema-Test-Suite/remotes/name.json'),
}

local options = {
  external_resolver = function(url)
    return external_schemas[url]
  end,
}

describe("[JSON schema Draft 4]", function()

  for _, descriptor in ipairs(supported) do
    for _, suite in ipairs(readjson(descriptor)) do
      local skipped = blacklist[suite.description] or {}
      if skipped ~= true then

        describe("["..descriptor.."] "..suite.description .. ":", function()
          local schema = suite.schema
          local validator

          lazy_setup(function()
            local val = assert(jsonschema.generate_validator(schema, options))
            assert.is_function(val)
            validator = val
            package.loaded.valcode = jsonschema.generate_validator_code(schema, options)
          end)

          for _, case in ipairs(suite.tests) do
            if not skipped[case.description] then
              local prefix = ""
              if (suite.description .. ": " .. case.description):find(
                "--something to run ONLY--", 1, true) then
                prefix = "#only "
              end
              it(prefix .. case.description, function()
                --print("data to validate: ", require("pl.pretty").write(case.data))
                if case.valid then
                  assert.has.no.error(function()
                    assert(validator(case.data))
                  end)
                else
                  local result, err
                  assert.has.no.error(function()
                    result, err = validator(case.data)
                  end)
                  if case.error then
                    assert.equal(case.error, err)
                  end
                  assert.has.error(function()
                    assert(result, err)
                  end)
                end
              end) -- it

            end -- case skipped
          end -- for cases
        end) -- describe

      end -- suite skipped
    end -- for suite
  end -- for descriptor

end) -- outer describe
