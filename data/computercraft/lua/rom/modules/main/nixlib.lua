local module = {}

module.testColor = function(value, maskOn, maskOff)
  return bit.band(value, bit.bor(maskOn, maskOff)) == maskOn
end

module.testBundledInput = function(side, maskOn, maskOff)
  return module.testColor(redstone.getBundledInput(side), maskOn, maskOff)
end

module.testColour = module.testColor

module.redstoneSides = function()
  local results = {}
  for i, side in ipairs(redstone.getSides()) do
    local power = redstone.getAnalogInput(side)
    if power > 0 then results[side] = { analog = power } end

    local clrs = redstone.getBundledInput(side)
    if clrs ~= 0 then results[side] = { bundled = clrs } end
  end

  return results
end

module.div = function(a, b)
  return { math.floor(a / b), a % b }
end

-- module.printPaged = function(text)
--   local w, h = term.getSize()
-- end

return module
