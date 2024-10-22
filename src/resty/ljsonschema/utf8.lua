-- compatibility module, for Lua 5.2 and earlier.

local ok, utf8 = pcall(require, "utf8")
if ok then
  return utf8 -- use the available build in module
end


-- define our own
local byte = string.byte
local ERR = 'Invalid UTF-8 encoding'

utf8 = {}



local function utf8_tail(c)
  return c >= 128 and c <= 191
end


local utf8_validator = function(s, i)

  local c1 = byte(s, i)
  if c1 >= 0 and c1 < 128 then
    -- ASCII
    return 1

  elseif c1 >= 194 and c1 <=223 then
    -- UTF8-2
    local c2 = byte(s, i + 1)
    if not c2 or not utf8_tail(c2) then
      return nil, ERR
    end

    return 2

  elseif c1 >= 224 and c1 <=239 then
    -- UTF8-3
    local c2 = byte(s, i + 1)
    local c3 = byte(s, i + 2)

    if not c2 or not c3 then
      return nil, ERR
    end

    if c1 == 224 and (c2 < 160 or c2 > 191) then
      return nil, ERR
    elseif c1 == 237 and (c2 < 128 or c2 > 159) then
      return nil, ERR
    elseif not utf8_tail(c2) then
      return nil, ERR
    end

    if not utf8_tail(c3) then
      return nil, ERR
    end

    return 3

  elseif c1 < 244 then
    local c2 = byte(s, i + 1)
    local c3 = byte(s, i + 2)
    local c4 = byte(s, i + 3)

    if not c2 or not c3 or not c4 then
      return nil, ERR
    end

    if c1 == 240 and (c2 < 144 or c2 > 191) then
      return nil, ERR
    elseif c1 == 244 and (c2 < 128 or c2 > 144) then
      return nil, ERR
    elseif not utf8_tail(c2) then
      return nil, ERR
    end

    if not utf8_tail(c3) or not utf8_tail(c4) then
      return nil, ERR
    end

    return 4
  end
end


-- this function is supposed to be compatible with Lua 5.3 and later.
-- Note: it only supports 1 parameter though!! so no substrings.
-- but this is good enough for the usecase with JSONschema.
utf8.len = function(s)
  local t = type(s)
  if t == "number" then
    s = tostring(s) -- convert number to string
  elseif t ~= 'string' then
    error("bad argument #1: expect 'string', got ".. type(s).. ")", 2)
  end

  local s_len = #s
  local pos = 1
  local l = 0

  while pos <= s_len do
    l = l + 1
    local n, err = utf8_validator(s, pos)
    if not n then
      return nil, err
    end

    pos = pos + n
  end

  return l
end



return utf8
