local jsonschema = require 'resty.ljsonschema'

local my_schema = {
  type = 'object',
  properties = {
    foo = { type = 'boolean' },
    bar = { type = 'number' },
  },
}

local validator          = jsonschema.generate_validator(my_schema)
local coercing_validator = jsonschema.generate_validator(my_schema, { coercion = true })

-- Now validate string values against our spec:
local my_data = { foo='true', bar='42' }
print(validator(my_data))            -->   false
print(coercing_validator(my_data))   -->   true
