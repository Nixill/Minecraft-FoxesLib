local module = {}

module.pkv = function(tbl, includekeys)
  includekeys = (includekeys ~= false)

  if type(tbl) == 'table' then

    for k, v in pairs(tbl) do
      if includekeys then
        print(k .. ': ' .. v)
      else
        print(v)
      end
    end
  end
end

module.printTable = module.pkv

return module
