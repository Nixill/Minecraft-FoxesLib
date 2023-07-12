local tables = {}

tables.pkv = function(tbl, includekeys)
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

tables.printTable = tables.pkv

tables.step = function(first, last, step)
  step = step or 1
  if step == 0 then step = 1 end
  if not last then
    last = first
    first = 1
  end

  results = {}
  for n = first, last, step do table.insert(results, n) end
  return results
end

tables.rangeTable = tables.step


return tables
