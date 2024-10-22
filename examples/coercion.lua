--[[

The use case for coercion is based on non-typed data. Typically when validating
a JSON payload, it is decoded, and by its nature, the decoded data has all elements
in their corresponding types. However, when the data is received as a string, and
it is not up front known the data is JSON, then we lack type information.

Typical example; OpenAPI specs that define a JSONschema for a header or query parameter.
These will always be strings. Now if you want to validate the strings "1", "100", "true",
"false", etc. against a JSONschema that expects integers or booleans, then automatic
coercion is the way to go.

]]

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
