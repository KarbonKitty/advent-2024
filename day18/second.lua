local startTime = os.time()

local fileHandle = assert(io.open("input", "r"))

local data = {}

for line in fileHandle:lines() do
    local x, y = line:match("(%d+),(%d+)")
    table.insert(data, { x = tonumber(x), y = tonumber(y) })
end

-- implementation goes here

local maxX = 70
local maxY = 70

local map = {}

for y = 0, maxY do
    map[y] = {}
    for x = 0, maxX do
        map[y][x] = "."
    end
end

local function addPoints(p1, p2)
    return { x = p1.x + p2.x, y = p1.y + p2.y }
end

local function pack(pos)
    return (pos.y << 8) + pos.x
end

local function unpack(package)
    local y = package >> 8
    local x = package - (y << 8)
    return { x = x, y = y }
end

local function heuristic(start, finish)
    return (finish.x - start.x) + (finish.y - start.y)
end

local function d(p1, p2)
    local c = (map[p2.y] or {})[p2.x]
    if c == nil or c == "#" then
        return 1 << 31
    end
    return 1
end

local function neighbors(position)
    return {
        addPoints(position, { x = -1, y = 0 }),
        addPoints(position, { x = 1, y = 0 }),
        addPoints(position, { x = 0, y = -1 }),
        addPoints(position, { x = 0, y = 1 })
    }
end

local function aStar(start, finish, h)
    local openSet = {}
    openSet[pack(start)] = true
    local gScore = {}
    gScore[pack(start)] = 0

    local fScore = {}
    fScore[pack(start)] = h(start, finish)

    while next(openSet) ~= nil do
        local min = 2 << 31
        local current
        for k, _ in pairs(openSet) do
            if (fScore[k] or (1 << 31)) < min then
                min = fScore[k]
                current = unpack(k)
            end
        end

        if pack(current) == pack(finish) then
            return gScore[pack(current)]
        end

        openSet[pack(current)] = nil

        for _, n in pairs(neighbors(current)) do
            local tentativeGScore = gScore[pack(current)] + d(current, n)
            local currentNeighborScore = gScore[pack(n)] or (1 << 31)
            if tentativeGScore < currentNeighborScore then
                gScore[pack(n)] = tentativeGScore
                fScore[pack(n)] = tentativeGScore + h(current, n)
                openSet[pack(n)] = true
            end
        end
    end
end

for i = 1, 1024 do
    local v = data[i]
    map[v.y][v.x] = "#"
end

local i = 1024
while true do
    local v = data[i]
    map[v.y][v.x] = "#"

    local score = aStar({ x = 0, y = 0 }, { x = maxX, y = maxY }, heuristic)

    if not score then
        print("Answer: (" .. v.x .. "," .. v.y .. ")")

        local endTime = os.time()
        print("Time spend (seconds):", os.difftime(endTime, startTime))
        return
    end

    i = i + 1
end

-- end of implementation
