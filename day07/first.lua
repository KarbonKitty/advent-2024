local fileData = assert(io.open("input", "r"))

local data = {}

for line in fileData:lines() do
    local result, rest = string.match(line, "(%d+):(.*)")
    local items = {}

    for m in string.gmatch(rest, "%d+") do
        table.insert(items, tonumber(m))
    end
    table.insert(data, { result = tonumber(result), items = items })
end

local function skip(t, num)
    local result = {}
    for i, v in ipairs(t) do
        if i > num then
            table.insert(result, v)
        end
    end
    return result
end

local function addNext(base, results, expectedResult, numbers)
    if #numbers == 0 then
        table.insert(results, base)
        return
    end

    local item = numbers[1]
    local copy = skip(numbers, 1)

    if base + item > expectedResult then
        return
    end

    if #copy == 0 then
        table.insert(results, base + item)
        return
    end

    addNext(base + item, results, expectedResult, copy)
    multiplyNext(base + item, results, expectedResult, copy)
end

function multiplyNext(base, results, expectedResult, numbers)
    if #numbers == 0 then
        table.insert(results, base)
        return
    end

    local item = numbers[1]
    local copy = skip(numbers, 1)

    if base * item > expectedResult then
        return
    end

    if #copy == 0 then
        table.insert(results, base * item)
        return
    end

    addNext(base * item, results, expectedResult, copy)
    multiplyNext(base * item, results, expectedResult, copy)
end

local function checkPossibilities(expectedResult, numbers)
    local item = numbers[1]
    local copy = skip(numbers, 1)
    local results = {}

    addNext(item, results, expectedResult, copy)
    multiplyNext(item, results, expectedResult, copy)

    for _, v in ipairs(results) do
        if v == expectedResult then
            return true
        end
    end

    return false
end

local total = 0

for _, v in pairs(data) do
    if checkPossibilities(v.result, v.items) then
        total = total + v.result
    end
end

print("result:", total)
