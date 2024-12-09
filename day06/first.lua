local fileData = assert(io.open("input", "r"))

local map = {}

for line in fileData:lines() do
    local mapLine = {}
    for m in string.gmatch(line, "%S") do
        table.insert(mapLine, m)
    end
    table.insert(map, mapLine)
end

local guard = { x = -1, y = -1, dir = "up" }

for y, l in ipairs(map) do
    for x, c in ipairs(l) do
        if c ~= "." and c ~= "#" then
            guard.x = x
            guard.y = y
            guard.dir = c == "^" and "up" or c == "v" and "down" or c == ">" and "right" or c == "<" and "left"
        end
    end
end

local maxX = #map
local maxY = #(map[1])

local turnDir = {
    up = "right",
    right = "down",
    down = "left",
    left = "up"
}

local function printMap()
    for i, l in ipairs(map) do
        print(table.concat(l, ""))
    end
end

local function charAt(x, y)
    local c = map[y][x]
    return c
end

local function setChar(x, y)
    map[y][x] = "X"
end

local function move()
    local newX = guard.x + (guard.dir == "left" and -1 or guard.dir == "right" and 1 or 0)
    local newY = guard.y + (guard.dir == "up" and -1 or guard.dir == "down" and 1 or 0)

    if newX <= 0 or newX > maxX or newY <= 0 or newY > maxY then
        setChar(guard.x, guard.y)
        return false
    end

    if charAt(newX, newY) == "#" then
        guard.dir = turnDir[guard.dir]
    else
        setChar(guard.x, guard.y)
        guard.x = newX
        guard.y = newY
    end

    return true
end

while move() do end

local count = 0

for _, l in ipairs(map) do
    for _, c in ipairs(l) do
        if c == "X" then
            count = count + 1
        end
    end
end

printMap()
print(count)
