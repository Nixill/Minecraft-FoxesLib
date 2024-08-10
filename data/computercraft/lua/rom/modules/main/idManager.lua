local r = require('foxeslib/random')

-- If computer doesn't have an access identifier string, give it one
if not fs.exists('.access/.ids.secret') then
  local file = fs.open('.access/.ids.secret', 'a')
  file.writeLine(r.getBase64(64))
  file.close()
end

-- Check the computer's access identifier string and return it
local file = fs.open('.access/.ids.secret', 'r')
local id = file.readLine()
file.close()
return id
