local module = {}

module.playAudio = function(path, volume)
  volume = volume or 1
  local dfpwm = require("cc.audio.dfpwm")
  local speaker = peripheral.find("speaker")

  local decoder = dfpwm.make_decoder()
  for chunk in io.lines(path, 16 * 1024) do
    local buffer = decoder(chunk)

    while not speaker.playAudio(buffer, volume) do
      os.pullEvent("speaker_audio_empty")
    end
  end
end
return module
