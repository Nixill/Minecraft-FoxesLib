local module = {}
if pcall(function() c = require('colorUtils') end) then
else
  c = require('modules/colorUtils')
end



module.upgrade = function(monitor)
  monitor.defaultBackground = monitor.getBackgroundColor()
  monitor.defaultText = monitor.getTextColor()

  monitor.setDefaultBackground = function(color)
    monitor.defaultBackground = color
    monitor.setBackgroundColor(monitor.defaultBackground)
  end

  monitor.setDefaultText = function(color)
    monitor.defaultText = color
    monitor.setTextColor(monitor.defaultText)
  end

  monitor.wipe = function()
    monitor.setBackgroundColor(monitor.defaultBackground)
    monitor.setTextColor(monitor.defaultText)
    monitor.setCursorPos(1, 1)
    monitor.clear()
  end

  monitor.resetPalette = function()
    for _, v in pairs(c.allColors) do
      monitor.setPaletteColor(v, term.nativePaletteColor(v))
    end
  end

  monitor.ezBlit = function(text, textColor, backgroundColor)
    text = tostring(text)
    bg = string.rep(colors.toBlit(backgroundColor or monitor.defaultBackground), #text)
    fg = string.rep(colors.toBlit(textColor or monitor.defaultText), #text)
    monitor.blit(text, fg, bg)
  end

  monitor.randomColors = function()
    local b = monitor.getBackgroundColor()
    local t = monitor.getTextColor()
    monitor.setPaletteColor(b, math.random(), math.random(), math.random())
    monitor.setPaletteColor(t, math.random(), math.random(), math.random())
  end

  monitor.nextLine = function()
    local x, y = monitor.getCursorPos()
    monitor.setCursorPos(x, y + 1)
  end
end

module.runOnAll = function(monitors, fxn, ...)
  local params = ...
  for _, v in pairs(monitors) do
    v[fxn](params)
  end
end

module.upgradeAll = function(monitors)
  for _, v in pairs(monitors) do
    module.upgrade(v)
  end
end

module.getAllMonitors = function()
  ms = { peripheral.find('monitor') }
  module.upgradeAll(ms)
  return ms
end

return module
