local tables = {}

tables.pkv = function(tbl, includekeys, lead)
  local function stringformatter(inp)
    if type(inp) == 'string' then
      return ("'" .. tostring(inp) .. "'")
    else
      return tostring(inp)
    end
  end

  includekeys = (includekeys ~= false)
  if not lead then lead = '' end
  lead = tostring(lead)

  if type(tbl) == 'table' then
    for k, v in pairs(tbl) do
      if includekeys then
        if type(v) ~= 'table' then
          print(lead .. tostring(k) .. ': ' .. stringformatter(v))
        else
          print(lead .. tostring(k) .. ': ')
          tables.pkv(v, includekeys, lead .. '  ')
        end
      else
        if type(v) ~= 'table' then
          print(stringformatter(v))
        else
          tables.pkv(v, includekeys, lead .. '  ')
        end
      end
    end
  end
end

tables.printTable = tables.pkv

tables.clone = function(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[tables.clone(orig_key)] = tables.clone(orig_value)
    end
    setmetatable(copy, tables.clone(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end


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

tables.union = function(source, add, duplicates)
  local results = {}
  local temp = {}

  for _, v in pairs(source) do
    if not duplicates and temp[v] then
    else
      temp[v] = true
      table.insert(results, v)
    end
  end

  for _, v in pairs(add) do
    if not duplicates and temp[v] then
    else
      temp[v] = true
      table.insert(results, v)
    end
  end
  return results
end

tables.difference = function(source, subtract, duplicates)
  --WORKS POORLY WITH NESTED TABLES
  local results = {}
  local temp = false
  subtract = tables.clone(subtract)

  for _, v in pairs(source) do
    if not duplicates then
      for _, w in pairs(subtract) do
        temp = false
        if v == w then
          temp = true
          break
        end
      end
      if temp == false then
        table.insert(results, v)
      end
    else
      for k, w in pairs(subtract) do
        temp = false
        if v == w then
          temp = true
          table.remove(subtract, k)
          break
        end
      end
      if temp == false then
        table.insert(results, v)
      end
    end
  end
  return results
end

tables.xor = function(t1, t2)
  local results = {}
  local temp1 = {}
  local temp2 = {}
  temp1 = tables.difference(t1, t2)
  temp2 = tables.difference(t2, t1)
  results = tables.union(temp1, temp2)
  return results
end

tables.compress = function(source)
  --WILL NOT NECESSARILY KEEP THE SAME ORDER
  if type(source) ~= 'table' then return { source } end
  local results = {}
  for _, v in pairs(source) do
    table.insert(results, v)
  end
  return results
end

tables.shuffle = function(source)
  local results = tables.compress(tables.clone(source))
  for i = #results, 2, -1 do
    local j = math.random(i)
    results[i], results[j] = results[j], results[i]
  end
  return results
end

return tables
