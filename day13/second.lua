local startTime = os.time()

local fileHandle = assert(io.open("input", "r"))

local data = {}

local counter = 0
local a, b, c, d, t, u
for line in fileHandle:lines() do
    counter = counter + 1
    if counter % 4 == 1 then
        a, b = string.match(line, "X%+(%d+), Y%+(%d+)")
    elseif counter % 4 == 2 then
        c, d = string.match(line, "X%+(%d+), Y%+(%d+)")
    elseif counter % 4 == 3 then
        t, u = string.match(line, "X=(%d+), Y=(%d+)")
        local tmp = { a = tonumber(a), b = tonumber(b), c = tonumber(c), d = tonumber(d), t = tonumber(t) + 10000000000000, u = tonumber(u) + 10000000000000 }
        table.insert(data, tmp)
    end
end

local total = 0

-- implementation goes here

for i, v in ipairs(data) do
    a, b, c, d, t, u = v.a, v.b, v.c, v.d, v.t, v.u

    local x = ((t * d) - (c * u)) / ((a * d) - (c * b))
    local y = ((a * u) - (t * b)) / ((a * d) - (c * b))
    if x > 0 and math.floor(x) == math.ceil(x) and y > 0 and math.floor(y) == math.ceil(y) then
        total = total + (x * 3) + y
    end
end

-- end of implementation

print("Answer:", total)

local endTime = os.time()
print("Time spend (seconds):", os.difftime(endTime, startTime))
