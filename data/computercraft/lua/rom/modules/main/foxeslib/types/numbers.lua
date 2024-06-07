local module = {}

module.div = function(a, b)
  return { math.floor(a / b), a % b }
end


return module
