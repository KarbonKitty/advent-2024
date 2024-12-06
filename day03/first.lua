local data = assert(io.open("input", "r"))

local sum = 0

for m, n in string.gmatch(data:read("a"), "mul%((%d+),(%d+)%)") do
    sum = sum + (m * n)
end

print(sum)
