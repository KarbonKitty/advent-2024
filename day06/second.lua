local fileData = assert(io.open("input", "r"))

local t = {}

for line in fileData:lines() do
    local mapLine = {}
    for m in string.gmatch(line, "%S") do
        table.insert(mapLine, m)
    end
    table.insert(t, mapLine)
end

local guard = { x = -1, y = -1, dir = "^" }
local startingPosition = { x = -1, y = -1, dir = "^" }

for y, l in ipairs(t) do
    for x, c in ipairs(l) do
        if c ~= "." and c ~= "#" then
            guard.x = x
            guard.y = y
            guard.dir = c
            startingPosition.x = x
            startingPosition.y = y
            startingPosition.dir = c
        end
    end
end

local maxX = #t
local maxY = #(t[1])

local turnDir = {
    ["^"] = ">",
    [">"] = "v",
    ["v"] = "<",
    ["<"] = "^"
}

local function printMap(mapCopy)
    for _, l in ipairs(mapCopy) do
        print(table.concat(l, ""))
    end
end

local function copyMap(m)
    local copy = {}
    for x, l in ipairs(m) do
        local line = {}
        for y, c in ipairs(l) do
            line[y] = c
        end
        copy[x] = line
    end
    return copy
end

local function charAt(mapCopy, x, y)
    local c = mapCopy[y][x]
    return c
end

local function setChar(mapCopy, x, y, char)
    mapCopy[y][x] = char
end

local function move(mapCopy)
    local newX = guard.x + (guard.dir == "<" and -1 or guard.dir == ">" and 1 or 0)
    local newY = guard.y + (guard.dir == "^" and -1 or guard.dir == "v" and 1 or 0)

    if newX <= 0 or newX > maxX or newY <= 0 or newY > maxY then
        return "exit", false
    end

    local c = charAt(mapCopy, newX, newY)
    if c == guard.dir then
        return "loop", false
    elseif c == "#" or c == "O" then
        guard.dir = turnDir[guard.dir]
    else
        setChar(mapCopy, guard.x, guard.y, guard.dir)
        guard.x = newX
        guard.y = newY
    end

    return nil, true
end

local function doesLoop(mapCopy)
    local result, cont, cnt
    cont = true
    cnt = 0
    while cont do
        cnt = cnt + 1
        -- sometimes the looping point is on a "crossroad"
        -- and dir alternates between vertical and horizontal
        -- and our loop detection fails
        -- this seems like a safe value to detect it anyway
        if cnt > 10000 then
            return "loop"
        end
        result, cont = move(mapCopy)
    end
    return result
end

local count = 0

for y, l in ipairs(t) do
    for x, c in ipairs(l) do
        if x == startingPosition.x and y == startingPosition.y then
        else
            local mapCopy = copyMap(t)
            guard.x = startingPosition.x
            guard.y = startingPosition.y
            guard.dir = startingPosition.dir
            setChar(mapCopy, x, y, "O")
            local result = doesLoop(mapCopy)
            if result == "loop" then
                count = count + 1
            end
        end
    end
end

print(count)
