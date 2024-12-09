local fileData = assert(io.open("input", "r"))

local rules = {}
local rulesHash = {}
local reverseRulesHash = {}
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

local function addRule(p, n)
    table.insert(rules, { tonumber(p), tonumber(n) })
    if not rulesHash[p] then
        rulesHash[p] = { n }
    else
        table.insert(rulesHash[p], n)
    end

    if not reverseRulesHash[n] then
        reverseRulesHash[n] = { p }
    else
        table.insert(reverseRulesHash[n], p)
    end
end

for line in fileData:lines() do
    local s, _, p, n = string.find(line, "(.*)|(.*)")
    if s ~= nil then
        addRule(tonumber(p), tonumber(n))
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

local function copyUpdate(update)
    local newUpdate = {}
    for i, v in ipairs(update) do
        newUpdate[i] = v
    end
    return newUpdate
end

local function intersection(s1, s2)
    local int = {}
    for _, n in ipairs(s1) do
        for _, m in ipairs(s2) do
            if n == m then
            int[n] = true
            end
        end
    end

    local retVal = {}

    for k, _ in pairs(int) do
        table.insert(retVal, k)
    end

    return retVal
end

local function indexOf(set, item)
    for i, v in ipairs(set) do
        if v == item then
            return i
        end
    end
    return -1
end

local function subset(super, sub)
    for _, v in pairs(sub or {}) do
        if indexOf(super, v) == -1 then
            return false
        end
    end
    return true
end

local function fixUpdate(update)
    local bagOfNumbers = copyUpdate(update)
    local ruledNumbers = {}
    local fixedUpdate = {}

    for _, number in ipairs(bagOfNumbers) do
        local furtherNumbers = intersection(rulesHash[number] or {}, bagOfNumbers)
        local previousNumbers = intersection(reverseRulesHash[number] or {}, bagOfNumbers)
        ruledNumbers[number] = { ["prev"] = previousNumbers or {}, ["next"] = furtherNumbers or {} }
    end

    for k, v in pairs(ruledNumbers) do
        if #v.prev == 0 then
            table.insert(fixedUpdate, k)
            table.remove(bagOfNumbers, indexOf(bagOfNumbers, k))
            ruledNumbers[k] = nil
            break
        end
    end

    while #bagOfNumbers > 0 do
        for k, v in pairs(ruledNumbers) do
            if subset(fixedUpdate, v.prev) then
                table.insert(fixedUpdate, k)
                table.remove(bagOfNumbers, indexOf(bagOfNumbers, k))
                ruledNumbers[k] = nil
            end
        end
    end

    return fixedUpdate
end

local sum = 0

for _, u in ipairs(updates) do
    if not validateUpdate(u) then
        local updatedUpdate = fixUpdate(u)

        local n = (1 + #updatedUpdate) / 2

        sum = sum + updatedUpdate[n]
    end
end

print(sum)
