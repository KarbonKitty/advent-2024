local startTime = os.time()

local fileHandle = assert(io.open("input", "r"))

local map = {}

for line in fileHandle:lines() do
    local dataLine = {}
    for m in string.gmatch(line, "%S") do
        local x
        if m == "#" then
            x = { "#", "#" }
        elseif m == "." then
            x = { ".", "." }
        elseif m == "@" then
            x = { "@", "." }
        elseif m == "O" then
            x = { "[", "]" }
        else
            x = { m }
        end
        table.insert(dataLine, x[1])
        table.insert(dataLine, x[2])
    end
    table.insert(map, dataLine)
end

local total = 0

-- implementation goes here
local robotLocation

for y, line in ipairs(map) do
    for x, c in ipairs(line) do
        if c == "@" then
            robotLocation = { x = x, y = y }
            break
        end
    end
end

local dirs = {
    [">"] = { x = 1, y = 0 },
    ["<"] = { x = -1, y = 0 },
    ["^"] = { x = 0, y = -1 },
    ["v"] = { x = 0, y = 1 }
}

local function printMap()
    for _, v in ipairs(map) do
        print(table.concat(v))
    end
end

local function addPoints(p1, p2)
    return { x = p1.x + p2.x, y = p1.y + p2.y }
end

local function canPushCrateVertical(left, right, dir)
    local newLeft = addPoints(left, dirs[dir])
    local newRight = addPoints(right, dirs[dir])
    local targetLeft = map[newLeft.y][newLeft.x]
    local targetRight = map[newRight.y][newRight.x]
    if targetLeft == "#" or targetRight == "#" then
        return false
    elseif targetLeft == "." and targetRight == "." then
        return true
    elseif targetLeft == "[" and targetRight == "]" then
        -- push one entire crate
        local canPush = canPushCrateVertical(newLeft, newRight, dir)
        return canPush
    elseif targetLeft == "]" and targetRight == "[" then
        -- push two crates, but only if both can be pushed
        local l = canPushCrateVertical(addPoints(newLeft, { x = -1, y = 0 }), newLeft, dir)
        local r = canPushCrateVertical(newRight, addPoints(newRight, { x = 1, y = 0 }), dir)
        return l and r
    elseif targetLeft == "]" then
        return canPushCrateVertical(addPoints(newLeft, { x = -1, y = 0 }), newLeft, dir)
    elseif targetRight == "[" then
        return canPushCrateVertical(newRight, addPoints(newRight, { x = 1, y = 0 }), dir)
    end
end

local function pushCrateVertical(left, right, dir)
    local newLeft = addPoints(left, dirs[dir])
    local newRight = addPoints(right, dirs[dir])
    local targetLeft = map[newLeft.y][newLeft.x]
    local targetRight = map[newRight.y][newRight.x]

    map[left.y][left.x] = "."
    map[right.y][right.x] = "."
    
    if targetLeft == "[" and targetRight == "]" then
        pushCrateVertical(newLeft, newRight, dir)
    else
        if targetLeft == "]" then
            pushCrateVertical(addPoints(newLeft, { x = -1, y = 0 }), newLeft, dir)
        end
        if targetRight == "[" then
            pushCrateVertical(newRight, addPoints(newRight, { x = 1, y = 0 }), dir)
        end
    end
    
    map[newLeft.y][newLeft.x] = "["
    map[newRight.y][newRight.x] = "]"
end

local function tryPushCrateHorizontal(left, right, dir)
    if dir == "<" then
        local newLeft = addPoints(left, { x = -1, y = 0 })
        local targetLeft = map[newLeft.y][newLeft.x]
        if targetLeft == "#" then
            return false
        elseif targetLeft == "." then
            map[newLeft.y][newLeft.x] = "["
            map[left.y][left.x] = "]"
            return true
        elseif targetLeft == "]" then
            local canPush = tryPushCrateHorizontal(
                addPoints(left, { x = -2, y = 0 }),
                addPoints(right, { x = -2, y = 0 }),
                dir
            )
            if canPush then
                map[newLeft.y][newLeft.x] = "["
                map[left.y][left.x] = "]"
            end
            return canPush
        end
    else
        local newRight = addPoints(right, { x = 1, y = 0 })
        local targetRight = map[newRight.y][newRight.x]
        if targetRight == "#" then
            return false
        elseif targetRight == "." then
            map[newRight.y][newRight.x] = "]"
            map[right.y][right.x] = "["
            return true
        elseif targetRight == "[" then
            local canPush = tryPushCrateHorizontal(
                addPoints(left, { x = 2, y = 0 }),
                addPoints(right, { x = 2, y = 0 }),
                dir
            )
            if canPush then
                map[newRight.y][newRight.x] = "]"
                map[right.y][right.x] = "["
            end
            return canPush
        end
    end
end

local function tryPush(what, where, dir)
    local newLocation = addPoints(where, dirs[dir])
    local targetType = map[newLocation.y][newLocation.x]
    if targetType == "#" then
        return false
    elseif targetType == "." then
        map[newLocation.y][newLocation.x] = what
        return true
    elseif dir == "^" or dir == "v" then
        local crateLeft, crateRight
        if targetType == "[" then
            crateLeft = newLocation
            crateRight = addPoints(newLocation, { x = 1, y = 0 })
        elseif targetType == "]" then
            crateLeft = addPoints(newLocation, { x = -1, y = 0 })
            crateRight = newLocation
        end

        local canPush = canPushCrateVertical(crateLeft, crateRight, dir)
        if canPush then
            pushCrateVertical(crateLeft, crateRight, dir)
            map[newLocation.y][newLocation.x] = what
        end
        return canPush
    else
        local crateLeft, crateRight
        if dir == "<" then
            crateLeft = addPoints(newLocation, dirs["<"])
            crateRight = newLocation
        else
            crateLeft = newLocation
            crateRight = addPoints(newLocation, dirs[">"])
        end
        local canPush = tryPushCrateHorizontal(crateLeft, crateRight, dir)
        if canPush then
            map[newLocation.y][newLocation.x] = what
        end
        return canPush
    end
end

local moveSequence = table.remove(map)
_ = table.remove(map)

for i, v in ipairs(moveSequence) do
    -- printMap()
    -- print(i, v)
    -- io.read()
    if tryPush("@", robotLocation, v) then
        map[robotLocation.y][robotLocation.x] = "."
        robotLocation = addPoints(robotLocation, dirs[v])
    end
end
printMap()

for y, line in ipairs(map) do
    for x, c in ipairs(line) do
        if c == "[" then
            total = total + ((y - 1) * 100 + (x - 1))
        end
    end
end

-- end of implementation

print("Answer:", total)

local endTime = os.time()
print("Time spend (seconds):", os.difftime(endTime, startTime))
