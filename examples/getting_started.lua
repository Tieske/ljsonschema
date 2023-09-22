local jsonschema = require 'resty.ljsonschema'

local my_schema = {
  type = 'object',
  properties = {
    foo = { type = 'string' },
    bar = { type = 'number' },
  },
}

-- Test our schema to be a valid JSONschema draft 4 spec, against
-- the meta schema:
assert(jsonschema.jsonschema_validator(my_schema))

-- Note: do cache the result of schema compilation as this is a quite
-- expensive process
local my_validator = jsonschema.generate_validator(my_schema)

-- Now validate some data against our spec:
local my_data = { foo='hello', bar=42 }
print(my_validator(my_data))
