local startTime = os.time()

local fileHandle = assert(io.open("input", "r"))

local towels = {}
local patterns = {}

for line in fileHandle:lines() do
    if string.match(line, ",") then
        for m in string.gmatch(line, "%w+") do
            table.insert(towels, m)
        end
    elseif string.match(line, "%S") then
        -- remove trailing newline
        table.insert(patterns, line:sub(1, line:len() - 1))
    end
end

local total = 0

-- implementation goes here

table.sort(towels, function (a, b) return a:len() > b:len() end)

local cache = {}

local function countWays(pattern)
    if pattern:len() == 0 then
        return 1
    end

    if cache[pattern] ~= nil then
        return cache[pattern]
    end

    local ways = 0

    for _, t in ipairs(towels) do
        local prefixLength = t:len()
        local patternPrefix = pattern:sub(1, prefixLength)
        if t == patternPrefix then
            ways = ways + countWays(pattern:sub(prefixLength + 1))
        end
    end

    cache[pattern] = ways

    return ways
end

for i, p in ipairs(patterns) do
    total = total + countWays(p)
end

-- end of implementation

print("Answer:", total)

local endTime = os.time()
print("Time spend (seconds):", os.difftime(endTime, startTime))
