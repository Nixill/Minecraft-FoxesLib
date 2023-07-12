local tables = {}

tables.pkv = function(tbl, includekeys, lead)
  includekeys = (includekeys ~= false)
  if not lead then lead = '' end
  lead = tostring(lead)

  if type(tbl) == 'table' then

    for k, v in pairs(tbl) do

      if includekeys then
        if type(v) ~= 'table' then
          print(lead .. tostring(k) .. ': ' .. v)
        else
          print(lead .. tostring(k) .. ': ')
          tables.pkv(v, includekeys, lead .. '  ')
        end

      else
        if type(v) ~= 'table' then
          print(v)
        else
          tables.pkv(v, includekeys, lead .. '  ')
        end
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

  local results = {}
  for n = first, last, step do table.insert(results, n) end
  return results
end

tables.rangeTable = tables.step

tables.contains = function(source, test, extractTable)
  extractTable = (extractTable ~= false)
  if type(test) ~= 'table' then
    for _, v in pairs(source) do
      if test == v then return true end
    end
    return false

  elseif not extractTable then
    for _, v in pairs(source) do
      if type(v) == 'table' then
        return (tables.contains(v, test) and tables.contains(test, v))
      end
    end
    return false

  else
    for _, t in pairs(test) do
      if not tables.contains(source, t, false) then return false end
    end
    return true
  end

end

tables.subset = function(source, test, extractTable)
  extractTable = (extractTable ~= false)
  local results = {}
  if type(test) ~= 'table' then
    for _, v in pairs(source) do
      if test == v then table.insert { results, v } end
    end

  elseif not extractTable then
    for _, v in pairs(source) do
      if type(v) == 'table' then
        if (tables.contains(v, test) and tables.contains(test, v)) then table.insert(results, v) end
      end
    end

  else
    for _, t in pairs(test) do
      if tables.contains(source, t, false) then table.insert(results, t) end
    end
  end

  return results
end

return tables
