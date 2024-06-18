-- Get the computer's access identifier string
local id = require('modules/idManager')

local dr = peripheral.find('drive')

-- Find the disk (or tablet), and add the access string to it's list

local driveRoot = dr.getMountPath()
local file = fs.open(driveRoot .. '/.access/.ids.secret', 'a')
file.writeLine(id)
file.close()
