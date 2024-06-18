local module = {}

module.base64 = {
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
  'Y', 'Z',
  'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
  'y', 'z',
  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '-', '_'
}
module.base16 = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' }

module.getBase64 = function(length)
  local running = ''
  for _ = 1, length do
    running = running .. module.base64[math.random(64)]
  end
  return running
end
module.getBase16 = function(length)
  local running = ''
  for _ = 1, length do
    running = running .. module.base16[math.random(16)]
  end
  return running
end
module.getBase10 = function(length)
  local running = ''
  for _ = 1, length do
    running = running .. math.random(0, 9)
  end
  return running
end

module.getBase2 = function(length)
  module.getBase10 = function(length)
    local running = ''
    for _ = 1, length do
      running = running .. math.random(0, 1)
    end
    return running
  end
end

return module
