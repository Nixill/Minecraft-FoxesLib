local module = {}
if pcall(function() c = require('colorUtils') end) then
else
  c = require('modules/colorUtils')
end


module.upgrade = function(term)
  term.defaultBackground = term.getBackgroundColor()
  term.defaultText = term.getTextColor()

  term.setDefaultBackground = function(color)
    term.defaultBackground = color
    term.setBackgroundColor(term.defaultBackground)
  end

  term.setDefaultText = function(color)
    term.defaultText = color
    term.setTextColor(term.defaultText)
  end

  term.wipe = function()
    term.setBackgroundColor(term.defaultBackground)
    term.setTextColor(term.defaultText)
    term.setCursorPos(1, 1)
    term.clear()
  end

  term.resetPalette = function()
    for _, v in pairs(c.allColors) do
      term.setPaletteColor(v, term.nativePaletteColor(v))
    end
  end

  term.ezBlit = function(text, textColor, backgroundColor)
    text = tostring(text)
    bg = string.rep(colors.toBlit(backgroundColor or term.defaultBackground), #text)
    fg = string.rep(colors.toBlit(textColor or term.defaultText), #text)
    term.blit(text, fg, bg)
  end

  term.randomColors = function()
    local b = term.getBackgroundColor()
    local t = term.getTextColor()
    term.setPaletteColor(b, math.random(), math.random(), math.random())
    term.setPaletteColor(t, math.random(), math.random(), math.random())
  end
  term.nextLine = function()
    local x, y = term.getCursorPos()
    term.setCursorPos(x, y + 1)
  end
end

return module
