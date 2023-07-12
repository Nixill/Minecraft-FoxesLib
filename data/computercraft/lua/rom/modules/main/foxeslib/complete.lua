local complete = {}

complete.autocomplete = function(currentText, listOptions, trailingSpace)
  local results = {}
  trailingSpace = (trailingSpace ~= false)
  for _, v in pairs(listOptions) do
    if string.sub(v, 1, #currentText) == currentText then
      local finish = string.sub(v, #currentText + 1)
      if trailingSpace then finish = finish .. ' ' end
      table.insert(results, finish)
    end
  end
  return results
end

return complete
