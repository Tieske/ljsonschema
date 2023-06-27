local json = require 'cjson'
json.decode_array_with_array_mt(true)
local jsonschema = require 'resty.ljsonschema'

describe("[number format, no precision loss]", function()

  it("integer", function()
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

    assert.same({
      false, "property value validation failed: expected -9007199254740992 to be greater than -9007199254740991"
    }, {
      my_validator({ value = min_safe_integer - 1 })
    })

    assert.same({
      false, "property value validation failed: expected 9007199254740992 to be smaller than 9007199254740991"
    }, {
      my_validator({ value = max_safe_integer + 1 })
    })
  end)


  it("float", function()
    local test_schema = {
      type = 'object',
      properties = {
        value= { type = 'number', minimum = -900719925474.12, maximum = 900719925474.12 },
      },
    }

    assert(jsonschema.jsonschema_validator(test_schema))
    local my_validator = jsonschema.generate_validator(test_schema)

    assert.same({
      false, "property value validation failed: expected -900719925474.123 to be greater than -900719925474.12"
    }, {
      my_validator({ value = -900719925474.123 })
    })

    assert.same({
      false, "property value validation failed: expected 900719925474.123 to be smaller than 900719925474.12"
    }, {
      my_validator({ value = 900719925474.123 })
    })
  end)

end)
