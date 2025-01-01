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

local function isPossible(pattern)
    if pattern:len() == 0 then
        return true
    end

    for _, t in ipairs(towels) do
        local prefixLength = t:len()
        local patternPrefix = pattern:sub(1, prefixLength)
        if t == patternPrefix then
            if isPossible(pattern:sub(prefixLength + 1)) then
                return true
            end
        end
    end

    return false
end

for _, p in pairs(patterns) do
    total = total + (isPossible(p) and 1 or 0)
end

-- end of implementation

print("Answer:", total)

local endTime = os.time()
print("Time spend (seconds):", os.difftime(endTime, startTime))
