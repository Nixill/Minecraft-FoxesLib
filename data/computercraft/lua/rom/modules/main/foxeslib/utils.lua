local module = {}

module.doorHandler = function(channel, name, side)
  --USE ONLY WITH ONE MODEM!
  local modem = peripheral.find('modem')
  modem.open(channel)
  local results = {}
  if type(name) ~= 'table' then
    results = { [tostring(name)] = true }
  else
    for k, v in pairs(name) do
      if v == true then
        results[k] = true
      else results[tostring(v)] = true
      end

    end
  end
  name = results

  while true do
    local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent('modem_message')
    if name[message] then
      redstone.setOutput(side, true)
      sleep(replyChannel)
      redstone.setOutput(side, false)
    end

  end
end

return module
