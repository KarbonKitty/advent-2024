local fileData = assert(io.open("input", "r"))

local rules = {}
local updates = {}

local function findPages(update, firstPage, secondPage)
    local f = -1
    local s = -1

    for i, p in ipairs(update) do
        if p == secondPage then
            s = i
        elseif p == firstPage then
            f = i
        end
    end
    return f, s
end

for line in fileData:lines() do
    local s, _, prev, next = string.find(line, "(.*)|(.*)")
    if s ~= nil then
        table.insert(rules, { tonumber(prev), tonumber(next) })
    elseif string.find(line, ",") then
        local pages = {}
        for m in string.gmatch(line, "(%d+),?") do
            table.insert(pages, tonumber(m))
        end
        table.insert(updates, pages)
    end
end

local function validateUpdate(update)
    for _, r in ipairs(rules) do
        local firstIndex, secondIndex = findPages(update, r[1], r[2])
        if firstIndex ~= -1 and secondIndex ~= -1 and firstIndex > secondIndex then
            return false
        end
    end
    return true
end

local sum = 0

for _, u in ipairs(updates) do
    if validateUpdate(u) then
        local n = (1 + #u) / 2
        sum = sum + u[n]
    end
end

print(sum)
