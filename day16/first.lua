local startTime = os.time()

local fileHandle = assert(io.open("input", "r"))

local data = {}

for line in fileHandle:lines() do
    local dataLine = {}
    for m in string.gmatch(line, "%S") do
        table.insert(dataLine, m)
    end
    table.insert(data, dataLine)
end

local total = 0

-- implementation goes here

local function printMap()
    for _, v in ipairs(data) do
        print(table.concat(v))
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

local function d(p1, p2, dir)
    local c = (data[p2.y] or {})[p2.x]
    if c == nil or c == "#" then
        return 1 << 31
    end
    if dir.x == p2.x - p1.x and dir.y == p2.y - p1.y then
        return 1
    end
    return 1001
end

local function neighbors(position)
    return {
        addPoints(position, { x = -1, y = 0 }),
        addPoints(position, { x = 1, y = 0 }),
        addPoints(position, { x = 0, y = -1 }),
        addPoints(position, { x = 0, y = 1 })
    }
end

local function rebuildPath(cameFrom, current)
    local path = {}
    while cameFrom[current] do
        current = cameFrom[current]
        table.insert(path, 1, current)
    end
    return path
end

local function aStar(start, finish, h)
    local openSet = {}
    openSet[pack(start)] = { x = 1, y = 0 }
    local gScore = {}
    gScore[pack(start)] = 0

    local cameFrom = {}

    local fScore = {}
    fScore[pack(start)] = h(start, finish)

    while next(openSet) ~= nil do
        local min = 2 << 31
        local current, dir
        for k, di in pairs(openSet) do
            if (fScore[k] or (1 << 31)) < min then
                min = fScore[k]
                current = unpack(k)
                dir = di
            end
        end

        if pack(current) == pack(finish) then
            return rebuildPath(cameFrom, pack(current)), gScore[pack(current)]
        end

        openSet[pack(current)] = nil

        for _, n in pairs(neighbors(current)) do
            local tentativeGScore = gScore[pack(current)] + d(current, n, dir)
            local currentNeighborScore = gScore[pack(n)] or (1 << 31)
            if tentativeGScore < currentNeighborScore then
                cameFrom[pack(n)] = pack(current)
                gScore[pack(n)] = tentativeGScore
                fScore[pack(n)] = tentativeGScore + h(current, n)
                openSet[pack(n)] = { x = n.x - current.x, y = n.y - current.y }
            end
        end
    end
end


local s, f

for y, l in ipairs(data) do
    for x, c in ipairs(l) do
        if c == "S" then
            s = { x = x, y = y }
        elseif c == "E" then
            f = { x= x, y = y }
        end
    end
end

_, total = aStar(s, f, heuristic)

print("Answer:", total)

local endTime = os.time()
print("Time spend (seconds):", os.difftime(endTime, startTime))
