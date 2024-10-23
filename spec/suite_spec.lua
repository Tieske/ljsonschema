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

    -- TODO: fix the ones below, introduced when updating testset to a newer version
    ['$ref prevents a sibling id from changing the base uri'] = {
      ['$ref resolves to /definitions/base_foo, data does not validate'] = true,
      ['$ref resolves to /definitions/base_foo, data validates'] = true,
    },
    ["Location-independent identifier"] = {
      ["match"] = true,
      ["mismatch"] = true,
    },
    ["Location-independent identifier with base URI change in subschema"] = {
      ["match"] = true,
      ["mismatch"] = true,
    },
    ["empty tokens in $ref json-pointer"] = {
      ["number is valid"] = true,
      ["non-number is invalid"] = true,
    },
    ["base URI change"] = {
      ["base URI change ref valid"] = true,
      ["base URI change ref invalid"] = true,
    },
    ["base URI change - change folder"] = {
      ["number is valid"] = true,
      ["string is invalid"] = true,
    },
    ["base URI change - change folder in subschema"] = {
      ["number is valid"] = true,
      ["string is invalid"] = true,
    },
    ["Location-independent identifier in remote ref"] = {
      ["integer is valid"] = true,
      ["string is invalid"] = true,
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
  'spec/JSON-Schema-Test-Suite/tests/draft4/id.json',
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
  'spec/JSON-Schema-Test-Suite/tests/draft4/infinite-loop-detection.json',
  'spec/extra/ref.json',
  -- format
  'spec/JSON-Schema-Test-Suite/tests/draft4/format.json',
  'spec/extra/format/date.json',
  'spec/extra/format/date-time.json',
  'spec/extra/format/time.json',
  'spec/extra/format/unknown.json',
  -- errors
  'spec/extra/errors/anyOf.json',
  'spec/extra/errors/types.json',
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
          local validator -- validator function (function)
          local validator_code -- validator function as code (string)

          lazy_setup(function()
            local val = assert(jsonschema.generate_validator(schema, options))
            assert.is_function(val)
            validator = val
            validator_code = jsonschema.generate_validator_code(schema, options)
          end)

          for _, case in ipairs(suite.tests) do
            if skipped[case.description] then
              pending(suite.description .. ": " .. case.description, function()end)
            else
              local prefix = ""
              if (suite.description .. ": " .. case.description):find(
                "--something to run ONLY--", 1, true) then
                prefix = "#only "
              end
              it(prefix .. case.description, function()
                -- print("data to validate: ", require("pl.pretty").write(case.data))
                assert(validator_code, "no code was generated") -- just here to prevent the linter from complaining
                -- print("validator function in use: \n" .. validator_code)
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
                    local errors = case.error
                    if type(errors) ~= "table" then
                      errors = { errors }
                    end
                    local matched = false
                    for _, e in ipairs(errors) do
                      if e == err then
                        matched = true
                        break
                      end
                    end
                    if not matched then
                      if #errors > 1 then
                        assert.equal({
                          ["expected one of these:"] = errors
                        }, err)
                      else
                        assert.equal(errors[1], err)
                      end
                    end
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
