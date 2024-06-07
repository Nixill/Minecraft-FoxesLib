local module = {}

local srep = string.rep

-- pad left side
module.lpad =
    function(s, l, c)
      local res = srep(c or ' ', l - #s) .. s

      return res
    end
-- pad right side
module.rpad =
    function(s, l, c)
      local res = s .. srep(c or ' ', l - #s)

      return res
    end

-- pad on both sides (centering with left justification)
module.pad =
    function(s, l, c)
      c = c or ' '

      local res1 = module.rpad(s, ((l - #s) / 2) + #s, c)
      local res2 = module.lpad(res1, l, c)

      return res2
    end

return module
