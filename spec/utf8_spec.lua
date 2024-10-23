describe("utf8 string test cases", function()

  local utf8_length



  setup(function()
    utf8_length = require("resty.ljsonschema.utf8").len
  end)



  it("nil input", function()
    assert.has_error(function() utf8_length(nil) end)
  end)


  it("number input", function()
    assert.are.equal(1, utf8_length(1))
    assert.are.equal(3, utf8_length(123))
  end)


  it("boolean input", function()
    assert.has_error(function() utf8_length(true) end)
  end)


  it("table input", function()
    assert.has_error(function() utf8_length({}) end)
  end)


  it("empty string", function()
    assert.are.equal(0, utf8_length(""))
  end)


  it("ascii string", function()
    assert.are.equal(5, utf8_length("hello"))
  end)


  it("utf8 string", function()
    assert.are.equal(2, utf8_length("你好"))
  end)


  it("utf8 string with euro sign", function()
    assert.are.equal(3, utf8_length("€€€"))
  end)


  it("utf8 string with emoji", function()
    assert.are.equal(3, utf8_length("👍👍👍"))
  end)


  it("utf8 string with emoji and euro sign", function()
    assert.are.equal(6, utf8_length("👍👍👍€€€"))
  end)


  it("utf8 string with emoji, euro sign and ascii", function()
    assert.are.equal(11, utf8_length("👍👍👍€€€hello"))
  end)


  it("utf8 string with emoji, euro sign, ascii and control characters", function()
    assert.are.equal(12, utf8_length("👍👍👍€€€hello\n"))
  end)


  -- Invalid byte sequences


  it("invalid two-byte sequence", function()
    assert.is_nil(utf8_length("\xC2"))
  end)


  it("invalid three-byte sequence", function()
    assert.is_nil(utf8_length("\xE0\x80"))
  end)


  it("invalid four-byte sequence", function()
    assert.is_nil(utf8_length("\xF0\x80\x80"))
  end)


  it("overlong encoding (two-byte)", function()
    assert.is_nil(utf8_length("\xC0\xAF"))
  end)


  it("overlong encoding (three-byte)", function()
    assert.is_nil(utf8_length("\xE0\x80\x80"))
  end)


  it("unexpected continuation byte", function()
    assert.is_nil(utf8_length("\x80"))
  end)


  it("invalid start byte (out of range)", function()
    assert.is_nil(utf8_length("\xF8\x80\x80\x80\x80"))
  end)


  it("mixed valid and invalid bytes", function()
    assert.is_nil(utf8_length("hello\x80world"))
  end)

end)
