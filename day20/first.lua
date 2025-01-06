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

local function aStar(start, finish, h, baseline)
    local openSet = {}
    openSet[pack(start)] = true
    local gScore = {}
    gScore[pack(start)] = 0

    local fScore = {}
    fScore[pack(start)] = h(start, finish)

    while next(openSet) ~= nil do
        local min = 1 << 31
        local current
        for k, _ in pairs(openSet) do
            if (fScore[k] or (1 << 31)) < min then
                min = fScore[k]
                current = unpack(k)
            end
        end

        if min > baseline then
            return baseline
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

local baseline = aStar(s, f, heuristic, 1 << 31)

local cheats = {}

-- this takes a pretty long time, on order of 400 seconds
-- TODO: since we're only looking at the savings of more than 100 picoseconds,
-- we might bail out if there's nothing in the open set that has the
-- score lower than baseline - 100?
for y, l in ipairs(data) do
    -- just to make sure we're not in some sort of infinite loop or something
    print(y)
    for x, c in ipairs(l) do
        if c == "#" then
            -- cheat when going through that wall
            data[y][x] = "."
            local new = aStar(s, f, heuristic, baseline)
            if baseline - new > 0 then
                table.insert(cheats, { x = x, y = y, val = baseline - new })
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
