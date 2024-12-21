local startTime = os.time()

local fileHandle = assert(io.open("input", "r"))

local map = {}

for line in fileHandle:lines() do
    local dataLine = {}
    for m in string.gmatch(line, "%S") do
        table.insert(dataLine, m)
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

local function tryPush(what, where, dir)
    local newLocation = addPoints(where, dirs[dir])
    local targetType = map[newLocation.y][newLocation.x]
    if targetType == "#" then
        return false
    elseif targetType == "." then
        map[newLocation.y][newLocation.x] = what
        return true
    else
        local canPush = tryPush(targetType, newLocation, dir)
        if canPush then
            map[newLocation.y][newLocation.x] = what
        end
        return canPush
    end
end

local moveSequence = table.remove(map)
_ = table.remove(map)

for _, v in ipairs(moveSequence) do
    if tryPush("@", robotLocation, v) then
        map[robotLocation.y][robotLocation.x] = "."
        robotLocation = addPoints(robotLocation, dirs[v])
    end
    -- printMap()
    -- io.read()
end
printMap()

for y, line in ipairs(map) do
    for x, c in ipairs(line) do
        if c == "O" then
            total = total + ((y - 1) * 100 + (x - 1))
        end
    end
end

-- end of implementation

print("Answer:", total)

local endTime = os.time()
print("Time spend (seconds):", os.difftime(endTime, startTime))
