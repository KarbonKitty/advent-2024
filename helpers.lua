local function printMap(map)
    for i, l in ipairs(map) do
        print(table.concat(l, ""))
    end
end

local function addPoints(p1, p2)
    return { x = p1.x + p2.x, y = p1.y + p2.y }
end

local function tryGetValue(p)
    if p.x < 1 or p.x > maxX or p.y < 1 or p.y > maxY then
        return false, nil
    else
        return true, map[p.y][p.x]
    end
end

local function getValueOrNil(p)
    local _, v = tryGetValue(p)
    return v
end
