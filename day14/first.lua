local startTime = os.time()

local fileHandle = assert(io.open("input", "r"))

local maxX, maxY = 101, 103
local timeLimit = 100

local left = math.floor(maxX / 2)
local right = math.ceil(maxX / 2)
local top = math.floor(maxY / 2)
local bottom = math.ceil(maxY / 2)

print(left, right)
print(top, bottom)

local data = {}

for line in fileHandle:lines() do
    local px, py, vx, vy = string.match(line, "p=(-?%d+),(-?%d+)%sv=(-?%d+),(-?%d+)")
    table.insert(data, { px = px, py = py, vx = vx, vy = vy })
end

local total = 0

local finalPositions = {}

-- implementation goes here
for i, v in ipairs(data) do
    local x = (v.px + (v.vx * timeLimit)) % maxX
    local y = (v.py + (v.vy * timeLimit)) % maxY
    table.insert(finalPositions, { x = x, y = y })
end

local topLeft = 0
local topRight = 0
local bottomLeft = 0
local bottomRight = 0

for i, v in ipairs(finalPositions) do
    if v.x < left and v.y < top then
        print("topLeft  ", v.x, v.y)
        topLeft = topLeft + 1
    elseif v.x >= right and v.y < top then
        print("topRight ", v.x, v.y)
        topRight = topRight + 1
    elseif v.x < left and v.y >= bottom then
        print("bottomLeft", v.x, v.y)
        bottomLeft = bottomLeft + 1
    elseif v.x >= right and v.y >= bottom then
        print("topRight  ", v.x, v.y)
        bottomRight = bottomRight + 1
    end
end

print(topLeft, topRight, bottomLeft, bottomRight)

-- end of implementation

print("Answer:", topLeft * topRight * bottomLeft * bottomRight)

local endTime = os.time()
print("Time spend (seconds):", os.difftime(endTime, startTime))
