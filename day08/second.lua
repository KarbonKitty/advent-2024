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
                local i = 0
                local positive = true
                local negative = true
                antinodes[location.y * maxY + location.x] = true
                while positive or negative do
                    i = i + 1
                    local positiveTestPosition = {
                        x = otherLocation.x + (i * diffX),
                        y = otherLocation.y + (i * diffY)
                    }
                    local negativeTestPosition = {
                        x = otherLocation.x - (i * diffX),
                        y = otherLocation.y - (i * diffY)
                    }
                    if isInBounds(positiveTestPosition) then
                        antinodes[positiveTestPosition.y * maxY + positiveTestPosition.x] = true
                        positive = true
                    else
                        positive = false
                    end

                    if isInBounds(negativeTestPosition) then
                        antinodes[negativeTestPosition.y * maxY + negativeTestPosition.x] = true
                        negative = true
                    else
                        negative = false
                    end
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
