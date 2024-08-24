local module = {}

module.xorEncrypt = function(value, key)
  local keyLength = #key
  local encrypted = ''
  for i = 0, #value - 1 do
    local keyIndex = (i % keyLength) + 1
    local valueChar = value:sub(i + 1, i + 1)
    local keyChar = key:sub(keyIndex, keyIndex)
    local encrChar = bit32.bxor(valueChar:byte(), keyChar:byte())
    encrypted = encrypted .. string.char(encrChar)
  end
  return encrypted
end

return module
