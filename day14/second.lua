local startTime = os.time()

local fileHandle = assert(io.open("input", "r"))

local maxX, maxY = 101, 103

local left = math.floor(maxX / 2)
local right = math.ceil(maxX / 2)
local top = math.floor(maxY / 2)
local bottom = math.ceil(maxY / 2)

local data = {}

for line in fileHandle:lines() do
    local px, py, vx, vy = string.match(line, "p=(-?%d+),(-?%d+)%sv=(-?%d+),(-?%d+)")
    table.insert(data, { px = px, py = py, vx = vx, vy = vy })
end

local total = 0


-- implementation goes here
local counter = 0
local doNotPrint = false
local lowestSoFar = 2 << 31

while true do
    local finalPositions = {}
    doNotPrint = false
    
    if counter % 100 == 0 then
        print("counter: ", counter)
    end
    counter = counter + 1

    for i, v in ipairs(data) do
        local x = (v.px + (v.vx * counter)) % maxX
        local y = (v.py + (v.vy * counter)) % maxY
        table.insert(finalPositions, { x = x, y = y })
    end

    local topLeft = 0
    local topRight = 0
    local bottomLeft = 0
    local bottomRight = 0

    for i, v in ipairs(finalPositions) do
        if v.x < left and v.y < top then
            topLeft = topLeft + 1
        elseif v.x >= right and v.y < top then
            topRight = topRight + 1
        elseif v.x < left and v.y >= bottom then
            bottomLeft = bottomLeft + 1
        elseif v.x >= right and v.y >= bottom then
            bottomRight = bottomRight + 1
        end
    end

    -- this is the kind of thing that makes one drop the Advent of Code
    -- in frustration,
    -- but apparently, it is a "very low entropy" configuration, for some reason
    local test = topLeft * topRight * bottomLeft * bottomRight

    if test < lowestSoFar then
        lowestSoFar = test
        local map = {}
        for i = 1, maxY do
            local line = {}
            for j = 1, maxX do
                table.insert(line, ".")
            end
            table.insert(map, line)
        end

        for k, v in pairs(finalPositions) do
            map[v.y + 1][v.x + 1] = "X"
        end

        for i, l in ipairs(map) do
            print(table.concat(l))
        end

        print(counter)
        -- if there's a tree in the picture, the number below the picture is the answer
        io.read()
    end

end
-- end of implementation
