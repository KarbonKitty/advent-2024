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

local maxY = #map
local maxX = #map[1]

local dirs = { { x = 1, y = 0 }, { x = -1, y = 0 }, { x = 0, y = 1 }, { x = 0, y = -1 }}

local function tryGetValue(p)
    if p.x < 1 or p.x > maxX or p.y < 1 or p.y > maxY then
        return false, nil
    else
        return true, map[p.y][p.x]
    end
end

local function addPoints(p1, p2)
    return { x = p1.x + p2.x, y = p1.y + p2.y }
end

local function printMap()
    for i, l in ipairs(map) do
        print(table.concat(l, ""))
    end
end

local currentPlant
local currentRegion = {}
local regionArea = 0
local regionPerimeter = 0

local mem = {}

for y, l in ipairs(map) do
    for x, c in ipairs(l) do
        if c ~= "." then
            regionArea = 0
            regionPerimeter = 0
            currentPlant = c
            mem = {}

            table.insert(currentRegion, { x = x, y = y })

            while #currentRegion > 0 do
                local nextLocation = table.remove(currentRegion)
                local _, plant = tryGetValue(nextLocation)
                if plant == currentPlant then
                    for _, dir in pairs(dirs) do
                        local testPoint = addPoints(nextLocation, dir)
                        local isInBounds, newChar = tryGetValue(testPoint)
                        if not isInBounds then
                            regionPerimeter = regionPerimeter + 1
                        elseif newChar == "^" then
                        elseif newChar == currentPlant then
                            table.insert(currentRegion, testPoint)
                            -- if c == "B" then printMap() end
                        else
                            regionPerimeter = regionPerimeter + 1
                        end
                    end
                end
                map[nextLocation.y][nextLocation.x] = "^"
                table.insert(mem, nextLocation)
            end

            for _, v in pairs(mem) do
                if map[v.y][v.x] == "^" then regionArea = regionArea + 1 end
                map[v.y][v.x] = "."
            end

            print(currentPlant, regionArea, regionPerimeter)
            total = total + (regionArea * regionPerimeter)
        end
    end
end

-- end of implementation

print("Answer:", total)

local endTime = os.time()
print("Time spend (seconds):", os.difftime(endTime, startTime))
