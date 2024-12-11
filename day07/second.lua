local startTime = os.time()

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

local numbers = {}

local function addNext(base, results, expectedResult, idx)
    if #numbers == idx then
        table.insert(results, base)
        return
    end

    local item = numbers[idx + 1]

    if base + item > expectedResult then
        return
    end

    if #numbers == idx + 1 then
        table.insert(results, base + item)
        return
    end

    addNext(base + item, results, expectedResult, idx + 1)
    multiplyNext(base + item, results, expectedResult, idx + 1)
    concatenateNext(base + item, results, expectedResult, idx + 1)
end

function multiplyNext(base, results, expectedResult, idx)
    if #numbers == idx then
        table.insert(results, base)
        return
    end

    local item = numbers[idx + 1]

    if base * item > expectedResult then
        return
    end

    if #numbers == idx + 1 then
        table.insert(results, base * item)
        return
    end

    addNext(base * item, results, expectedResult, idx + 1)
    multiplyNext(base * item, results, expectedResult, idx + 1)
    concatenateNext(base * item, results, expectedResult, idx + 1)
end

function concatenateNext(base, results, expectedResult, idx)
    if #numbers == idx then
        table.insert(results, base)
        return
    end

    local item = numbers[idx + 1]
    local concatenationResult = tonumber(base .. item)

    if concatenationResult > expectedResult then
        return
    end

    if #numbers == idx + 1 then
        table.insert(results, concatenationResult)
        return
    end

    addNext(concatenationResult, results, expectedResult, idx + 1)
    multiplyNext(concatenationResult, results, expectedResult, idx + 1)
    concatenateNext(concatenationResult, results, expectedResult, idx + 1)
end

local function checkPossibilities(expectedResult)
    local item = numbers[1]
    local results = {}

    addNext(item, results, expectedResult, 1)
    multiplyNext(item, results, expectedResult, 1)
    concatenateNext(item, results, expectedResult, 1)

    for _, v in ipairs(results) do
        if v == expectedResult then
            return true
        end
    end

    return false
end

local total = 0

for _, v in pairs(data) do
    numbers = v.items
    if checkPossibilities(v.result) then
        total = total + v.result
    end
end

local endTime = os.time()

print("result:", total)
print(os.difftime(endTime, startTime))
