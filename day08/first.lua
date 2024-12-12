local startTime = os.time()

local fileData = assert(io.open("input", "r"))

local map = {}

for line in fileData:lines() do
    local mapLine = {}
    for c in string.gmatch(line, "%S") do
        table.insert(mapLine, c)
    end
    table.insert(map, mapLine)
end

local antennas = {}

local maxY = #map
local maxX = #map[1]

for r, row in ipairs(map) do
    for c, char in ipairs(row) do
        if char ~= "." then
            local antennaList = antennas[char] or {}
            table.insert(antennaList, { x = c, y = r })
            antennas[char] = antennaList
        end
    end
end

local antinodes = {}

local function isInBounds(pair)
    return pair.x > 0 and pair.x <= maxX and pair.y > 0 and pair.y <= maxY
end

for _, locations in pairs(antennas) do
    for _, location in ipairs(locations) do
        for _, otherLocation in ipairs(locations) do
            local diffX = location.x - otherLocation.x
            local diffY = location.y - otherLocation.y
            if diffX ~= 0 or diffY ~= 0 then
                local firstAntinode = { x = location.x - (2 * diffX), y = location.y - (2 * diffY) }
                local secondAntinode = { x = location.x + diffX, y = location.y + diffY }
                if isInBounds(firstAntinode) then
                    antinodes[firstAntinode.y * 1000 + firstAntinode.x] = true
                end
                if isInBounds(secondAntinode) then
                    antinodes[secondAntinode.y * 1000 + secondAntinode.x] = true
                end
            end
        end
    end
end

local total = 0

for _, _ in pairs(antinodes) do
    total = total + 1
end

local endTime = os.time()

print(total)
print(os.difftime(endTime, startTime))
