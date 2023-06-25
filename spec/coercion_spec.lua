local json = require 'cjson'
json.decode_array_with_array_mt(true)
local jsonschema = require 'resty.ljsonschema'

describe("[string coercion]", function()

  describe("number:", function()

    local schema = {
        type = "number",
        minimum = 1.1,
        maximum = 3,
        exclusiveMinimum = true,
    }

    it("coerces a number", function()
      local validator = assert(jsonschema.generate_validator(
        schema, {
          coercion = true,
        }))
      assert.is_false(validator("1"))
      assert.is_false(validator("1.1"))
      assert.is_true(validator("2"))
      assert.is_true(validator("3"))
    end)

    it("does not coerce a number if not set to do so", function()
      local validator = assert(jsonschema.generate_validator(
        schema, {
          coercion = false,
        }))
      assert.is_false(validator("1"))
      assert.is_false(validator("1.1"))
      assert.is_false(validator("2"))
      assert.is_false(validator("3"))
    end)

  end)

  describe("integer:", function()

    local schema = {
        type = "integer",
        minimum = 1,
        maximum = 3,
        exclusiveMinimum = true,
    }

    it("coerces an integer", function()
      local validator = assert(jsonschema.generate_validator(
        schema, {
          coercion = true,
        }))
      assert.is_false(validator("1"))
      assert.is_true(validator("2"))
      assert.is_true(validator("3"))
    end)

    it("does not coerce an integer if not set to do so", function()
      local validator = assert(jsonschema.generate_validator(
        schema, {
          coercion = false,
        }))
      assert.is_false(validator("1"))
      assert.is_false(validator("2"))
      assert.is_false(validator("3"))
    end)

  end)

  describe("boolean:", function()

    local schema = {
        type = "boolean",
    }

    it("coerces a number", function()
      local validator = assert(jsonschema.generate_validator(
        schema, {
          coercion = true,
        }))
      assert.is_false(validator("no boolean"))
      assert.is_true(validator("true"))
      assert.is_true(validator("false"))
    end)

    it("does not coerce a boolean if not set to do so", function()
      local validator = assert(jsonschema.generate_validator(
        schema, {
          coercion = false,
        }))
      assert.is_false(validator("no boolean"))
      assert.is_false(validator("true"))
      assert.is_false(validator("false"))
    end)

  end)

  describe("type list (boolean and number)", function()

    local schema = {
        type = { "number", "boolean"},
        minimum = 1.1,
        maximum = 3,
        exclusiveMinimum = true,
    }

    it("coerces a number", function()
      local validator = assert(jsonschema.generate_validator(
        schema, {
          coercion = true,
        }))
      assert.is_false(validator("1"))
      assert.is_false(validator("1.1"))
      assert.is_true(validator("2"))
      assert.is_true(validator("3"))
    end)

  end)

  describe("safe integer range", function()
    it("sanity", function()
      local min_safe_integer = -9007199254740991
      local max_safe_integer = 9007199254740991

      local test_schema = {
        type = 'object',
        properties = {
          value= { type = 'integer', minimum = min_safe_integer, maximum = max_safe_integer },
        },
      }

      assert(jsonschema.jsonschema_validator(test_schema))
      local my_validator = jsonschema.generate_validator(test_schema)

      local result, msg = my_validator({ value = min_safe_integer - 1 })
      assert.is_false(result)
      assert.equal("property value validation failed: expected -9007199254740992 to be greater than -9007199254740991", msg)

      local result, msg = my_validator({ value = max_safe_integer + 1 })
      assert.is_false(result)
      assert.equal("property value validation failed: expected 9007199254740992 to be smaller than 9007199254740991", msg)
    end)

    it("number", function()
      local test_schema = {
        type = 'object',
        properties = {
          value= { type = 'number', minimum = -900719925474.12, maximum = 900719925474.12 },
        },
      }

      assert(jsonschema.jsonschema_validator(test_schema))
      local my_validator = jsonschema.generate_validator(test_schema)

      local result, msg = my_validator({ value = -900719925474.123 })
      assert.is_false(result)
      assert.equal("property value validation failed: expected -900719925474.123 to be greater than -900719925474.12", msg)

      local result, msg = my_validator({ value = 900719925474.123 })
      assert.is_false(result)
      assert.equal("property value validation failed: expected 900719925474.123 to be smaller than 900719925474.12", msg)
    end)
  end)
end)
