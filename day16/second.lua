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
    -- dirX and dirY can be -1, 0 or 1, so we add 2 to make them positive
    -- otherwise shifting them around messes with the results
    local packed =  ((pos.dirY + 2) << 20) + ((pos.dirX + 2) << 16) + (pos.y << 8) + pos.x
    return packed
end

local function unpack(package)
    local dirY = package >> 20
    local dirX = (package >> 16) - (dirY << 4)
    local y = (package >> 8) - (dirX << 8) - (dirY << 12)
    local x = package - (y << 8) - (dirX << 16) - (dirY << 20)
    -- see pack() for why we do -2 for dirX and dirY
    return { x = x, y = y, dirX = dirX - 2, dirY = dirY - 2 }
end

local function heuristic(start, finish)
    return (finish.x - start.x) + (finish.y - start.y)
end

local function d(p1, p2)
    local c = (data[p2.y] or {})[p2.x]
    if c == nil or c == "#" then
        return 1 << 31
    end

    -- we nudge the pathfinder to look for a different path that uses as little
    -- of the old path as possible
    local cost = (c == "O" and 1 / 1024 or 0)

    if p1.x ~= p2.x or p1.y ~= p2.y then
        -- different square
        cost = cost + 1
    end

    if (math.abs(p1.dirX - p2.dirX) == 2) or (math.abs(p1.dirY - p2.dirY) == 2) then
        -- 180 turn
        cost = cost + 2000
    elseif (p1.dirX ~= p2.dirX) or (p1.dirY ~= p2.dirY) then
        -- 90 turn
        cost = cost + 1000
    end

    return cost
end

local function neighborDirs(list, position)
    -- really only useful for checking which orientation of the finish tile
    -- ended up being the lowest cost
    table.insert(list, { x = position.x, y = position.y, dirX = -1, dirY = 0 })
    table.insert(list, { x = position.x, y = position.y, dirX = 1, dirY = 0 })
    table.insert(list, { x = position.x, y = position.y, dirX = 0, dirY = -1 })
    table.insert(list, { x = position.x, y = position.y, dirX = 0, dirY = 1 })
end

local function neighbors(position)
    local n = {}
    local dir = { x = position.dirX, y = position.dirY }
    local newPos = addPoints(position, dir)
    -- next tile in the current direction
    table.insert(n, { x = newPos.x, y = newPos.y, dirX = dir.x, dirY = dir.y })

    -- other directions (but not the one we are already in)
    if dir.x ~= -1 and dir.y ~= 0 then
        table.insert(n, { x = position.x, y = position.y, dirX = -1, dirY = 0 })
    end
    if dir.x ~= 1 and dir.y ~= 0 then
        table.insert(n, { x = position.x, y = position.y, dirX = 1, dirY = 0 })
    end
    if dir.x ~= 0 and dir.y ~= 1 then
        table.insert(n, { x = position.x, y = position.y, dirX = 0, dirY = 1 })
    end
    if dir.x ~= 0 and dir.y ~= -1 then
        table.insert(n, { x = position.x, y = position.y, dirX = 0, dirY = -1 })
    end
    return n
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
    start.dirX = 1
    start.dirY = 0
    local openSet = {}
    openSet[pack(start)] = true
    local gScore = {}
    gScore[pack(start)] = 0

    local cameFrom = {}

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

        -- if pack(current) == pack(finish) then
        --     return rebuildPath(cameFrom, pack(current)), gScore[pack(current)]
        -- end

        openSet[pack(current)] = nil

        for _, n in pairs(neighbors(current)) do
            local tentativeGScore = gScore[pack(current)] + d(current, n)
            local currentNeighborScore = gScore[pack(n)] or (1 << 31)
            if tentativeGScore < currentNeighborScore then
                -- print("current: (" .. current.x .. "," .. current.y .. ";" .. current.dirX.. "," .. current.dirY .. ") n: (" .. n.x .. "," .. n.y .. ";" .. n.dirX .. "," .. n.dirY .. ")" .. " score: " .. tentativeGScore)
                cameFrom[pack(n)] = pack(current)
                gScore[pack(n)] = tentativeGScore
                fScore[pack(n)] = tentativeGScore + h(current, n)
                openSet[pack(n)] = { x = n.x - current.x, y = n.y - current.y }
            end
        end
    end

    -- shortest path to finish
    local t = {}
    neighborDirs(t, finish)

    local trueFinish
    local minScore = 1 << 31
    for k, v in pairs(t) do
        if gScore[pack(v)] < minScore then
            minScore = gScore[pack(v)]
            trueFinish = v
        end
    end

    return rebuildPath(cameFrom, pack(trueFinish)), gScore, trueFinish
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



local seats = 0
local lastSeats = 0

repeat
    local path, score, trueFinish = aStar(s, f, heuristic)
    lastSeats = seats
    seats = 0

    for i, p in ipairs(path) do
        local pos = unpack(p)
        data[pos.y][pos.x] = "O"
    end

    printMap()
    print(score[pack(trueFinish)])

    for _, l in ipairs(data) do
        for _, c in ipairs(l) do
            if c == "O" then
                seats = seats + 1
            end
        end
    end
until seats == lastSeats

print("Answer:", seats + 1)

local endTime = os.time()
print("Time spend (seconds):", os.difftime(endTime, startTime))
