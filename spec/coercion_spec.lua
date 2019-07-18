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


end)