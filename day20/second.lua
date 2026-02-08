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
    local c = (data[p2.y] or {})[p2.x]
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

local baseline = aStar(s, f, heuristic)

local cheats = {}

-- TODO: this will not work
-- with longer "cheat period"
-- current idea: keep track of (x, y, didWeAlreadyTeleport) triple
-- and when searching for the next move consider "teleporting"
-- (moving up to 19 units of distance)
-- as one of the 'neighbors'
-- (really, up to 19^2 neighbors)
-- but this will make it hard to find _all_ the cheats
for y, l in ipairs(data) do
    print(y)
    for x, c in ipairs(l) do
        if c == "#" then
            -- cheat when going through that wall
            data[y][x] = "."
            local new = aStar(s, f, heuristic)
            if baseline - new > 0 then
                table.insert(cheats, { x = x, y = y, val = baseline - new })
                -- print(x, y, baseline - new)
            end
            -- fix the wall
            data[y][x] = "#"
        end
    end
end

table.sort(cheats, function (a, b) return a.val > b.val end)

for i, c in ipairs(cheats) do
    print(c.x, c.y, c.val)
    if c.val >= 100 then
        total = total + 1
    end
end

-- end of implementation

print("Answer:", total)

local endTime = os.time()
print("Time spend (seconds):", os.difftime(endTime, startTime))
