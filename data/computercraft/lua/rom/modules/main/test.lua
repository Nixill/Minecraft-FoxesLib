local var = 0
local module = {}

function module.addOne()
  var = var + 1
  return var
end

return module