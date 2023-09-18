local json = require 'cjson'
json.decode_array_with_array_mt(true)
local jsonschema = require 'resty.ljsonschema'

describe("[array detection]", function()
  local schema = {
      type = "array",
      elements = "string",
  }

  describe("default:", function()

    it("requires explicit metatable tagging with cjson.array_mt", function()
      local validator = assert(jsonschema.generate_validator(
        schema, {
          array_mt = nil,
        }))

      assert.is_true(validator(setmetatable({}, json.array_mt)))
      assert.is_true(validator(setmetatable({ "a", "b", "c" }, json.array_mt)))
      assert.is_false(validator({}))
      assert.is_false(validator({ "a", "b", "c" }))
      assert.is_false(validator({ a = 1, b = 2 }))
      assert.is_false(validator({ "a", "b", "c", a = 1, b = 2 }))
    end)

  end)

  describe("array_mt == false:", function()

    it("detects arrays via heuristic", function()
      local validator = assert(jsonschema.generate_validator(
        schema, {
          array_mt = false,
        }))

      assert.is_true(validator(setmetatable({}, json.array_mt)))
      assert.is_true(validator(setmetatable({ "a", "b", "c" }, json.array_mt)))
      assert.is_true(validator({}))
      assert.is_true(validator({ "a", "b", "c" }))
      assert.is_false(validator({ a = 1, b = 2 }))
      assert.is_false(validator({ "a", "b", "c", a = 1, b = 2 }))
    end)

  end)

  describe("array_mt == <table>:", function()

    it("checks for the custom metatable", function()
      local array_mt = {}

      local validator = assert(jsonschema.generate_validator(
        schema, {
          array_mt = array_mt,
        }))

      assert.is_true(validator(setmetatable({}, array_mt)))
      assert.is_true(validator(setmetatable({ "a", "b", "c" }, array_mt)))
      assert.is_false(validator({}))
      assert.is_false(validator({ "a", "b", "c" }))
      assert.is_false(validator({ a = 1, b = 2 }))
      assert.is_false(validator({ "a", "b", "c", a = 1, b = 2 }))
    end)

  end)

end)
