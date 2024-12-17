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

local dirs = { { x = 0, y = 1 }, { x = 0, y = -1 }, { x = 1, y = 0 }, { x = -1, y = 0 } }

local maxY = #map
local maxX = #map[1]

local function tryGetValue(p)
    if p.x < 1 or p.x > maxX or p.y < 1 or p.y > maxY then
        return false, nil
    else
        return true, map[p.y][p.x]
    end
end

local function getValueOrNil(p)
    local _, v = tryGetValue(p)
    return v
end

local function addPoints(p1, p2)
    return { x = p1.x + p2.x, y = p1.y + p2.y }
end

local function checkCorner(position)
    local topLeft = getValueOrNil({ x = position.x - 1, y = position.y - 1}) == "^"
    local topRight = getValueOrNil({ x = position.x - 1, y = position.y}) == "^"
    local bottomLeft = getValueOrNil({ x = position.x, y = position.y - 1}) == "^"
    local bottomRight = getValueOrNil({ x = position.x, y = position.y}) == "^"

    local count = (topLeft and 1 or 0) + (topRight and 1 or 0) + (bottomLeft and 1 or 0) + (bottomRight and 1 or 0)

    if count == 1 or count == 3 then
        return 1
    elseif count == 2 and ((topRight and bottomLeft) or (topLeft and bottomRight)) then
        return 2
    else
        return 0
    end
end

local function addCorners(list, position)
    -- top left corner, no offset on the list
    list[(position.y << 16) + position.x] = checkCorner(position)
    -- top right corner, offset x by one
    list[(position.y << 16) + position.x + 1] = checkCorner(addPoints(position, { x = 1, y = 0 }))
    -- bottom left corner, offset y by one
    list[((position.y + 1) << 16) + position.x] = checkCorner(addPoints(position, { x = 0, y = 1 }))
    -- bottom right, offset both
    list[((position.y + 1) << 16) + position.x + 1] = checkCorner(addPoints(position, { x = 1, y = 1 }))
end

for y, l in ipairs(map) do
    for x, c in ipairs(l) do
        if c ~= "." then
            local currentRegion = {}
            local regionArea = 0
            local regionPerimeter = 0
            local currentPlant = c
            local mem = {}

            table.insert(currentRegion, { x = x, y = y })

            while #currentRegion > 0 do
                local nextLocation = table.remove(currentRegion)
                local _, plant = tryGetValue(nextLocation)
                if plant == currentPlant then
                    for _, dir in pairs(dirs) do
                        local testPoint = addPoints(nextLocation, dir)
                        local isInBounds, newChar = tryGetValue(testPoint)
                        if isInBounds and newChar == currentPlant then
                            table.insert(currentRegion, testPoint)
                        end
                    end
                end
                map[nextLocation.y][nextLocation.x] = "^"
                table.insert(mem, nextLocation)
            end

            -- count perimeter
            local corners = {}
            for _, v in pairs(mem) do
                if map[v.y][v.x] == "^" then addCorners(corners, v) end
            end

            for _, v in pairs(corners) do
                regionPerimeter = regionPerimeter + v
            end
            -- count area
            for _, v in pairs(mem) do
                if map[v.y][v.x] == "^" then regionArea = regionArea + 1 end
                map[v.y][v.x] = "."
            end

            -- print(currentPlant, regionArea, regionPerimeter)
            total = total + (regionArea * regionPerimeter)
        end
    end
end

-- end of implementation

print("Answer:", total)

local endTime = os.time()
print("Time spend (seconds):", os.difftime(endTime, startTime))
