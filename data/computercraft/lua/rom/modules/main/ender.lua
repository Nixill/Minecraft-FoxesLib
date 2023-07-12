local module = {}

local data = {
  blue = {letter = "B", value = 0xB},
  cyan = {letter = "C", value = 0x9},
  grey = {letter = "D", value = 0x7},
  green = {letter = "G", value = 0xD},
  black = {letters = {sides = "K", center = "Z"}, value = 0xF},
  lime = {letter = "L", value = 0x5},
  magenta = {letter = "M", value = 0x2},
  brown = {letter = "N", value = 0xC},
  orange = {letter = "O", value = 0x1},
  pink = {letter = "P", value = 0x6},
  red = {letter = "R", value = 0xE},
  silver = {letter = "S", value = 0x8},
  light_blue = {letter = "U", value = 0x3},
  purple = {letter = "V", value = 0xA},
  white = {letter = "W", value = 0x0},
  yellow = {letter = "Y", value = 0x4}
}

local aliases = {
  gray = "grey",
  light_gray = "silver",
  light_green = "lime",
  light_grey = "silver",
  sky = "light_blue",
  teal = "cyan",
  violet = "purple"
}

local function getLetter(color, isCenter)
  color = color:lower()
  local cData = data[color] or data[aliases[color]]

  if not cData then
    -- No color data found
    error(color .. " is not a valid color!")
  elseif cData.letter then
    -- Color data has one letter
    return cData.letter
  elseif isCenter then
    -- Color data has two letters, and we want center letter
    return cData.letters.center
  else
    return cData.letters.sides
  end
end

module.getAcronym = function(left, center, right)
  return getLetter(left, false) .. getLetter(center, true) .. getLetter(right, false)
end

local function getChannel(color)
  color = color:lower()
  local cData = data[color] or data[aliases[color]]

  if not cData then
    -- No color data found
    error(color .. " is not a valid color!")
  else
    return cData.value
  end
end

module.getChannel = function(left, center, right, reply)
  return
    0x2000
    + (0x100 * getChannel(left))
    + (0x10 * getChannel(center))
    + (0x1 * getChannel(right))
    + (reply and 0x1000 or 0x0000)
end

return module
