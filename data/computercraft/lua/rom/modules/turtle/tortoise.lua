local tortoise = {}

local position = vector.new(0, 0, 0)
local facing = vector.new(0, 0, -1)
local gpsSet = false

function tortoise.debug()
  return {position=position, facing=facing, gpsSet=gpsSet}
end

function tortoise.calibrate()
  -- First, get the current position.
  local x, y, z = gps.locate(1)

  if x == nil then
    return false, "Cannot use GPS."
  end
  position = vector.new(x, y, z)
  local rotation = 0
  
  -- Now attempt to get an adjacent position.
  for i = 0, 3 do
    if turtle.forward() then
      x, y, z = gps.locate(1)
      local newPos = vector.new(x, y, z)
      facing = newPos - position
      gpsSet = true
      -- Attempt to move back to original position
      if turtle.back() then
        tortoise.turnLeft(i) -- uses module call to also update facing vector accordingly
        return true, "Calibrated successfully."
      else
        position = newPos
        return nil, "Calibrated successfully, but could not return to original position."
      end
    else
      turtle.turnRight()
    end
  end

  -- If we've finished the loop and couldn't move...
  return false, "Calibrated current position, but couldn't move."
end

function tortoise.reset()
  position = vector.new(0, 0, 0)
  facing = vector.new(0, 0, -1)
  gpsSet = false
end

function tortoise.turnLeft(amount)
  amount = tonumber(amount) or 1
  amount = (amount + 1) % 4 - 1
  if amount < 0 then return tortoise.turnRight(-amount) end
  for i = 1, amount do
    turtle.turnLeft()
    facing = vector.new(facing.z, 0, -facing.x)
  end
  return -amount
end

function tortoise.turnRight(amount)
  amount = tonumber(amount) or 1
  amount = (amount + 1) % 4 - 1
  if amount < 0 then return tortoise.turnLeft(-amount) end
  for i = 1, amount do
    turtle.turnRight()
    facing = vector.new(-facing.z, 0, facing.x)
  end
  return amount
end

function tortoise.turnAround()
  return tortoise.turnRight(2)
end

function tortoise.faceRelative(vec)
  local vec2 = nil

  if math.abs(vec.x) > math.abs(vec.z) then
    vec2 = vector.new(vec.x, 0, 0):normalize()
  else
    vec2 = vector.new(0, 0, vec.z):normalize()
  end

  local turns = 0

  while vec2.x ~= facing.x or vec2.z ~= facing.z do
    tortoise.turnRight()
    turns = turns + 1
  end

  return turns
end

function tortoise.faceNorth()
  return tortoise.faceRelative(vector.new(0, 0, -1))
end

function tortoise.faceSouth()
  return tortoise.faceRelative(vector.new(0, 0, 1))
end

function tortoise.faceEast()
  return tortoise.faceRelative(vector.new(1, 0, 0))
end

function tortoise.faceWest()
  return tortoise.faceRelative(vector.new(-1, 0, 0))
end

function tortoise.faceBlock(block)
  return tortoise.faceRelative(block - position)
end

function tortoise.turn(turn)
  if tonumber(turn) ~= nil then
    tortoise.turnRight(turn)
    return (turn + 1) % 4 - 1
  elseif turn == "right" or turn == "r" then
    tortoise.turnRight(1)
    return 1
  elseif turn == "left" or turn == "l" then
    tortoise.turnLeft(1)
    return -1
  elseif turn == "around" or turn == "a" then
    tortoise.turnRight(2)
    return 2
  elseif turn == "north" or turn == "n" then
    return tortoise.faceNorth()
  elseif turn == "east" or turn == "e" then
    return tortoise.faceEast()
  elseif turn == "south" or turn == "s" then
    return tortoise.faceSouth()
  elseif turn == "west" or turn == "w" then
    return tortoise.faceWest()
  end
  return 0
end

local function moveStraight(move, offset, distance, afterMove, turnOnEnd, traverseOffset)
  -- First set the params to defaults if necessary.
  local distance = tonumber(distance) or 1
  local traverseOffset = tonumber(traverseOffset) or 0

  -- Allow placeholder string functions
  if type(afterMove) ~= "function" then
    afterMove = nil
  end

  if turnOnEnd == nil or turnOnEnd == "reset" then
    turnOnEnd = 0
  end

  local turned = 0

  -- This variable keeps track of how far we've gone.
  local traversed = 0

  while traversed < distance do
    -- Attempt to move.
    local success, reason = move()
    if success then
      -- Record successful move.
      traversed = traversed + 1
      position = position + offset
      -- If we're on the last move, turn.
      if traversed == distance then
        turned = tortoise.turn(turnOnEnd)
      end
      -- Perform afterMove function.
      if afterMove ~= nil then
        local amSuccess, amOffset = afterMove(traversed + traverseOffset, distance + traverseOffset, turnOnEnd)
        -- We'll allow nil to mean true, as in keep going
        if amSuccess == false or amSuccess == "cancel" then
          return false, traversed, turned, "Post-move function returned false."
        elseif amSuccess == "nil" then -- string "nil" because nil is true so that functions not returning a value don't cause fails
          return nil, traversed, turned, "Post-move function returned nil."
        elseif amSuccess == "finish" then
          return true, traversed, turned, "Post-move function returned finish."
        end
        if amOffset ~= nil then
          traversed = traversed + amOffset
        end
      end
    else
      return false, traversed, turned, reason
    end
  end

  return true, traversed, turned, nil
end

function tortoise.forward(distance, afterMove, turnOnEnd, traverseOffset)
  return moveStraight(turtle.forward, facing, distance, afterMove, turnOnEnd, traverseOffset)
end

function tortoise.back(distance, afterMove, turnAtEnd, traverseOffset)
  return moveStraight(turtle.back, -facing, distance, afterMove, turnAtEnd, traverseOffset)
end

function tortoise.up(distance, afterMove, turnAtEnd, traverseOffset)
  return moveStraight(turtle.up, vector.new(0, 1, 0), distance, afterMove, turnAtEnd, traverseOffset)
end

function tortoise.down(distance, afterMove, turnAtEnd, traverseOffset)
  return moveStraight(turtle.down, vector.new(0, -1, 0), distance, afterMove, turnAtEnd, traverseOffset)
end

local function moveTurned(turn, distance, afterMove, turnOnEnd, traverseOffset)
  local turned = tortoise.turn(turn)

  if turnOnEnd == false then
    turnOnEnd = -turned
  end

  local success, traversed, turned2, reason = tortoise.forward(distance, afterMove, turnOnEnd, traverseOffset)

  return success, traversed, (turned + turned2 + 1) % 4 - 1, reason
end

function tortoise.moveLeft(distance, afterMove, turnOnEnd, traverseOffset)
  return moveTurned(-1, distance, afterMove, turnOnEnd, traverseOffset)
end

function tortoise.moveRight(distance, afterMove, turnOnEnd, traverseOffset)
  return moveTurned(1, distance, afterMove, turnOnEnd, traverseOffset)
end

function tortoise.move180(distance, afterMove, turnOnEnd, traverseOffset)
  return moveTurned(2, distance, afterMove, turnOnEnd, traverseOffset)
end

function tortoise.moveNorth(distance, afterMove, turnOnEnd, traverseOffset)
  return moveTurned("north", distance, afterMove, turnOnEnd, traverseOffset)
end

function tortoise.moveSouth(distance, afterMove, turnOnEnd, traverseOffset)
  return moveTurned("south", distance, afterMove, turnOnEnd, traverseOffset)
end

function tortoise.moveEast(distance, afterMove, turnOnEnd, traverseOffset)
  return moveTurned("east", distance, afterMove, turnOnEnd, traverseOffset)
end

function tortoise.moveWest(distance, afterMove, turnOnEnd, traverseOffset)
  return moveTurned("west", distance, afterMove, turnOnEnd, traverseOffset)
end

function tortoise.moveToX(target, afterMove, turnOnEnd, traverseOffset)
  local deltaX = target - position.x
  if deltaX > 0 then
    return tortoise.moveEast(deltaX, afterMove, turnOnEnd, traverseOffset)
  elseif deltaX < 0 then
    return tortoise.moveWest(-deltaX, afterMove, turnOnEnd, traverseOffset)
  else
    return nil, 0, 0, "No need to move."
  end
end

function tortoise.moveToY(target, afterMove, turnOnEnd, traverseOffset)
  local deltaY = target - position.y
  if deltaY > 0 then
    return tortoise.up(deltaY, afterMove, turnOnEnd, traverseOffset)
  elseif deltaY < 0 then
    return tortoise.down(-deltaY, afterMove, turnOnEnd, traverseOffset)
  else
    return nil, 0, 0, "No need to move."
  end
end

function tortoise.moveToZ(target, afterMove, turnOnEnd, traverseOffset)
  local deltaZ = target - position.z
  if deltaZ > 0 then
    return tortoise.moveSouth(deltaZ, afterMove, turnOnEnd, traverseOffset)
  elseif deltaZ < 0 then
    return tortoise.moveNorth(-deltaZ, afterMove, turnOnEnd, traverseOffset)
  else
    return nil, 0, 0, "No need to move."
  end
end

function tortoise.multiMove(moves)
  local traversed = 0
  local tOffset = moves.start or 0
  local totalTurn = 0
  
  for i = 1, #moves do
    local call = moves[i]
    if type(call.func) == "string" then
      call.func = tortoise[call.func] or tortoise["move" .. call.func:upper():sub(1, 1) .. call.func:sub(2)]
    end

    if call.func == nil and call.multiMove == nil then
      return false, traversed, totalTurn, "Function called doesn't exist."
    end
      
    local loops = 1
    
    while true do
      local cSuccess, cTrav, cTurn, cReason
      
      if call.multiMove then
        call.multiMove.start = (call.multiMove.start or 0) + traversed + tOffset
        cSuccess, cTrav, cTurn, cReason = tortoise.multiMove(call.multiMove)
      else
        if call.traversed then
          call[call.traversed] = (tonumber(call[call.traversed]) or 0) + traversed + tOffset
        end
        cSuccess, cTrav, cTurn, cReason = call.func(table.unpack(call))
      end
      
      totalTurn = (totalTurn + cTurn + 1) % 4 - 1
      traversed = traversed + cTrav
      
      if not cSuccess then
        return cSuccess, traversed, totalTurn, cReason
      end      
      
      if not (call.loops or call.during) then break end
      if call.loops and call.loops <= loops then break end
      if call.during and not call.during() then break end

      loops = loops + 1
    end
  end
    
  return true, traversed, totalTurn, nil
end

-- Sweeps the rectangle provided. It goes from the space the turtle is in to the space (forward) and (right) of it. Returns to the original position after finishing.
function tortoise.sweep(forward, right, afterMove, turnOnEnd)
  -- First, correct for rectangles that go left or backward instead of right and forward.
  if forward < 0 then
    if right < 0 then
      tortoise.turnAround()
      tortoise.sweep(-forward, -right, afterMove, 0)
      tortoise.turnAround()
      tortoise.turn(turnOnEnd)
    else
      tortoise.turnRight()
      tortoise.sweep(right, -forward, afterMove, 0)
      tortoise.turnLeft()
      tortoise.turn(turnOnEnd)
    end
  else
    if right < 0 then
      tortoise.turnLeft()
      tortoise.sweep(-right, forward, afterMove, 0)
      tortoise.turnRight()
      tortoise.turn(turnOnEnd)
    else
      turn = 1
      width = right

      while true do
        local success, moved, turned, reason = tortoise.forward(forward, afterMove, turn)
        if not success then return false end
        if right >= 1 then
          local success, moved, turned, reason = tortoise.forward(1, afterMove, turn)
          if not success then return false end
          right = right - 1
          turn = -turn
        else
          if turn == 1 then
            os.sleep(1)
            tortoise.turnAround()
            local success, moved, turned, reason = tortoise.forward(forward, nil, "right")
            if not success then return false end
          else
            os.sleep(1)
            tortoise.turnAround()
          end
          local success, moved, turned, reason = tortoise.forward(width, nil, "right")
          if not success then return false end
          if type(afterMove) == "function" then
            afterMove(1)
          end
          break
        end
      end

      tortoise.turn(turnOnEnd)
    end
  end
end

function tortoise.selectItem(itemName, minCount)
  minCount = minCount or 1
  local prev = turtle.getSelectedSlot()
  -- Special case for "air" to select empty slots
  if itemName == "minecraft:air" or itemName == nil then
    for i = 1, 16 do
      local details = turtle.getItemDetail(i, false)
      if details == nil then
        turtle.select(i)
        return true, i, prev
      end
    end
  else
    for i = 1, 16 do
      local details = turtle.getItemDetail(i, false)
      if details ~= nil then
        if (details.name == itemName or itemName == "*") and details.count >= minCount then
          turtle.select(i)
          return true, i, prev
        end
      end
    end
  end
  return false, nil, prev
end

return tortoise
