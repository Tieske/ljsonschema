local jsonschema = require 'resty.ljsonschema'

local my_schema = {
  type = 'object',
  properties = {
    foo = { type = 'string', format = 'date' },
    bar = { type = 'string', format = 'date-time' },
    baz = { type = 'string', format = 'time' },
  },
}

local my_validator = jsonschema.generate_validator(my_schema)

-- Now validate some data against our spec:
local my_data = {
  foo='2020-02-29',
  bar='2020-02-29T08:30:00Z',
  baz='08:30:60Z'
}
print(my_validator(my_data))   --> true

my_data = {
  foo='20200-02-29',           --> Invalid date specified
  bar='2020-02-29T08:30:00Z',
  baz='08:30:06.283185+00:20'
}
print(my_validator(my_data))   --> false
