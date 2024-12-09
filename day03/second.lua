local dataFile = assert(io.open("input", "r"))
local data = dataFile:read("a")

local sum = 0
local position = 1

while position < string.len(data) do
    local _, nextDontEnd = string.find(data, "don't()", position, true)
    local substr = string.sub(data, position, nextDontEnd)
    for m, n in string.gmatch(substr, "mul%((%d+),(%d+)%)") do
        sum = sum + (m * n)
    end
    position = nextDontEnd or string.len(data)
    local _, nextDoEnd = string.find(data, "do()", position, true)
    position = nextDoEnd or string.len(data)
end

print(sum)
