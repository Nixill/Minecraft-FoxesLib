tbl = require('foxeslib/tables')
local cards = {}


local deckTable = {}
local suits = { 's', 'c', 'h', 'd' }
for _, v in pairs(tbl.step(13)) do
  for _, w in pairs(suits) do
    if v == 1 then
      disp = 'A'
    elseif v == 11 then
      disp = 'J'
    elseif v == 12 then
      disp = 'Q'
    elseif v == 13 then
      disp = 'K'
    else
      disp = tostring(v)
    end

    if v > 10 then
      val = 10
    else
      val = v
    end

    if w == 's' or w == 'c' then
      col = colors.black
    else
      col = colors.red
    end

    temp = {
      number = v,
      suit = w,
      value = val,
      display = disp .. ' - ' .. w,
      color = col
    }
    table.insert(deckTable, temp)
  end
end


cards.deck = function(count, shuffle)
  if type(count) ~= 'number' then
    return deckTable
  end
  local stack = {}
  for i = 1, count do
    stack = tbl.union(stack, deckTable, true)
  end
  if shuffle then stack = tbl.shuffle(stack) end
  return stack
end

return cards
