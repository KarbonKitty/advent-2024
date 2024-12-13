local startTime = os.time()

local fileData = assert(io.open("input", "r"))

local map = {}

for line in fileData:lines() do
    local mapLine = {}
    for c in string.gmatch(line, "%d") do
        table.insert(mapLine, tonumber(c))
    end
    table.insert(map, mapLine)
end

local dirs = { { x = 1, y = 0 }, { x = -1, y = 0 }, { x = 0, y = 1 }, { x = 0, y = -1 } }

local maxY = #map
local maxX = #map[1]

local function tryGetValue(x, y)
    if x < 1 or x > maxX or y < 1 or y > maxY then
        return false, nil
    else
        return true, map[y][x]
    end
end

local function mergeTables(t1, t2)
    for i=1,#t2 do
        t1[#t1 + 1] = t2[i]
    end
end

local function addPoints(p1, p2)
    return { x = p1.x + p2.x, y = p1.y + p2.y }
end

local function nextStep(startingPoint, expectedValue)
    local isInBounds, actualValue = tryGetValue(startingPoint.x, startingPoint.y)
    if not isInBounds or actualValue ~= expectedValue then
        return {}
    elseif expectedValue == 9 then
        return { startingPoint }
    else
        local results = {}
        for _, dir in pairs(dirs) do
            mergeTables(results, nextStep(addPoints(startingPoint, dir), expectedValue + 1))
        end
        return results
    end
end

local function followTrails(startingPoint)
    local results = {}
    for _, dir in pairs(dirs) do
        mergeTables(results, nextStep(addPoints(startingPoint, dir), 1))
    end

    local set = {}
    for _, v in pairs(results) do
        set[v.y * maxY + v.x] = true
    end

    local score = 0
    for _, v in pairs(set) do
        score = score + 1
    end

    return score
end

local total = 0

for y, row in ipairs(map) do
    for x, val in ipairs(row) do
        if val == 0 then
            local score = followTrails({ x = x, y = y })
            total = total + score
        end
    end
end

local endTime = os.time()

print(total)

print("elapsed time", os.difftime(endTime, startTime))
