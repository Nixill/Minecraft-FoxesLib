if not turtle then
    printError("Requires a Turtle")
    return
end

local tArgs = { ... }
if #tArgs < 1 then
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage: " .. programName .. " <direction> <distance>")
    return
end

local tortoise = require("tortoise")

local mHandlers = {
    -- Full name of move method       , Main abbreviation           ,    Two letters                ,    One letter
    ["calibrate"] = tortoise.calibrate, ["cal"] = tortoise.calibrate,    ["ca"] = tortoise.calibrate,    ["c"] = tortoise.calibrate,
    ["forward"] = tortoise.forward,     ["fwd"] = tortoise.forward,      ["fd"] = tortoise.forward,      ["f"] = tortoise.forward,
    ["backward"] = tortoise.back,       ["back"] = tortoise.back,        ["bk"] = tortoise.back,         ["b"] = tortoise.back,
    ["up"] = tortoise.up,                                                                                ["u"] = tortoise.up,
    ["down"] = tortoise.down,                                            ["dn"] = tortoise.down,         ["d"] = tortoise.down,
    ["left"] = tortoise.moveLeft,                                        ["lt"] = tortoise.moveLeft,     ["l"] = tortoise.moveLeft,
    ["moveleft"] = tortoise.moveLeft,                                    ["mvlt"] = tortoise.moveLeft,   ["ml"] = tortoise.moveLeft,
    ["right"] = tortoise.moveRight,                                      ["rt"] = tortoise.moveRight,    ["r"] = tortoise.moveRight,
    ["moveright"] = tortoise.moveRight,                                  ["mvrt"] = tortoise.moveRight,  ["mr"] = tortoise.moveRight,
    ["180deg"] = tortoise.move180,      ["180d"] = tortoise.move180,
    ["around"] = tortoise.move180,                                       ["ar"] = tortoise.move180,      ["a"] = tortoise.move180,
    ["move180deg"] = tortoise.move180,  ["move180d"] = tortoise.move180, ["mv180d"] = tortoise.move180,  ["m180d"] = tortoise.move180,
    --[[]]                              ["move180"] = tortoise.move180,  ["mv180"] = tortoise.move180,   ["m180"] = tortoise.move180,
    ["movearound"] = tortoise.move180,                                   ["mvad"] = tortoise.move180,    ["ma"] = tortoise.move180,
    ["north"] = tortoise.moveNorth,                                      ["no"] = tortoise.moveNorth,    ["n"] = tortoise.moveNorth,
    ["movenorth"] = tortoise.moveNorth,                                  ["mvno"] = tortoise.moveNorth,  ["mn"] = tortoise.moveNorth,
    ["south"] = tortoise.moveSouth,                                      ["so"] = tortoise.moveSouth,    ["s"] = tortoise.moveSouth,
    ["movesouth"] = tortoise.moveSouth,                                  ["mvso"] = tortoise.moveSouth,  ["ms"] = tortoise.moveSouth,
    ["east"] = tortoise.moveEast,                                        ["ea"] = tortoise.moveEast,     ["e"] = tortoise.moveEast,
    ["moveeast"] = tortoise.moveEast,                                    ["mvea"] = tortoise.moveEast,   ["me"] = tortoise.moveEast,
    ["west"] = tortoise.moveWest,                                        ["we"] = tortoise.moveWest,     ["w"] = tortoise.moveWest,
    ["movewest"] = tortoise.moveWest,                                    ["mvwe"] = tortoise.moveWest,   ["mw"] = tortoise.moveWest,
    ["tox"] = tortoise.moveToX,                                          ["tx"] = tortoise.moveToX,      ["x"] = tortoise.moveToX,
    ["movetox"] = tortoise.moveToX,                                      ["mvtx"] = tortoise.moveToX,    ["mx"] = tortoise.moveToX,
    ["toy"] = tortoise.moveToY,                                          ["ty"] = tortoise.moveToY,      ["y"] = tortoise.moveToY,
    ["movetoy"] = tortoise.moveToY,                                      ["mvty"] = tortoise.moveToY,    ["my"] = tortoise.moveToY,
    ["toz"] = tortoise.moveToZ,                                          ["tz"] = tortoise.moveToZ,      ["z"] = tortoise.moveToZ,
    ["movetoz"] = tortoise.moveToZ,                                      ["mvtz"] = tortoise.moveToZ,    ["mz"] = tortoise.moveToZ,
    ["turnright"] = tortoise.turnRight,                                  ["tnrt"] = tortoise.turnRight,  ["tr"] = tortoise.turnRight,
    ["turnleft"] = tortoise.turnLeft,                                    ["tnlt"] = tortoise.turnLeft,   ["tl"] = tortoise.turnLeft,
    ["turnaround"] = tortoise.turnAround,                                ["tnar"] = tortoise.turnAround, ["ta"] = tortoise.turnAround,
    ["facenorth"] = tortoise.faceNorth,                                  ["fano"] = tortoise.faceNorth,  ["fn"] = tortoise.faceNorth,
    ["facesouth"] = tortoise.faceSouth,                                  ["faso"] = tortoise.faceSouth,  ["fs"] = tortoise.faceSouth,
    ["faceeast"] = tortoise.faceEast,                                    ["faea"] = tortoise.faceEast,   ["fe"] = tortoise.faceEast,
    ["facewest"] = tortoise.faceWest,                                    ["fawe"] = tortoise.faceWest,   ["fw"] = tortoise.faceWest
}

local tHandlers = {
    -- Main alias        , Two letters      , One letter
    ["left"] = "left",     ["lt"] = "left",   ["l"] = "left",
    ["right"] = "right",   ["rt"] = "right",  ["r"] = "right",
    ["around"] = "around", ["ar"] = "around", ["a"] = "around",
    ["north"] = "north",   ["no"] = "north",  ["n"] = "north",
    ["south"] = "south",   ["so"] = "south",  ["s"] = "south",
    ["east"] = "east",     ["ea"] = "east",   ["e"] = "east",
    ["west"] = "west",     ["we"] = "west",   ["w"] = "west",
    ["reset"] = false,     ["re"] = false,
    [-4] = 0, [-3] = 1, [-2] = 2, [-1] = -1, [0] = 0, [1] = 1, [2] = 2, [3] = -1, [4] = 0
}

local nArg = 1
while nArg <= #tArgs do
    local sDirection = tArgs[nArg]:lower()
    local nDistance = 1
    local eTurn = 0
    local program = nil

    if nArg < #tArgs then
        local num = tonumber(tArgs[nArg + 1])
        if num then
            nDistance = num
            nArg = nArg + 1

            if tArgs[nArg + 1] == "turn" then
                if tArgs[nArg + 2] then
                    local turn = tArgs[nArg + 2]
                    if tHandlers[turn:lower()] then
                        eTurn = tHandlers[turn:lower()]
                        nArg = nArg + 2
                    else
                        print("No such turn direction: " .. sDirection)
                        print("Try: left, right, around, north, south, east, west")
                        return
                    end
                else
                    nArg = nArg + 1
                end
            end

            if tArgs[nArg + 1] == "with" then
                local programString = tArgs[nArg + 2]
                if programString then
                    local slashExists, slashIndex = programString:find("/")
                    local programName, programArg

                    if slashExists then
                        programName = programString:sub(1, slashIndex - 1)
                        programArg = programString:sub(slashIndex + 1)
                    else
                        programName = programString
                    end

                    local success, result = pcall(require, "goto/" .. programName)

                    if success and type(result) == "function" then
                        local programResult = result(programArg)
                        if type(programResult) == "function" then
                            program = programResult
                        else
                            print("Invalid program: " .. programName)
                            if type(programResult) == "string" then
                                print(programResult)
                            end
                            return
                        end
                    else
                        print("No such program: " .. programName)
                        return
                    end

                    nArg = nArg + 2
                else
                    nArg = nArg + 1
                end
            end
        end
    end

    nArg = nArg + 1

    local fnHandler = mHandlers[string.lower(sDirection)]
    if fnHandler then
        local success, traversed, turned, reason = fnHandler(nDistance, program, eTurn, 0)
        if success == false then
            print("Turtle failed to move:")
            if type(traversed) == "string" then -- calibrate returns reason second arg, not fourth
                print(traversed)
            else
                print(reason)
            end
            return
        end
    else
        print("No such direction: " .. sDirection)
        print("Try: forward, back, up, down")
        return
    end
end