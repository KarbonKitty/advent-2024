local startTime = os.time()

local fileHandle = assert(io.open("example", "r"))

local data = {}

for line in fileHandle:lines() do
    local dataLine = {}
    for m in string.gmatch(line, "%S") do
        table.insert(dataLine, m)
    end
    table.insert(data, dataLine)
end

local total = 0

-- implementation goes here
-- end of implementation

print("Answer:", total)

local endTime = os.time()
print("Time spend (seconds):", os.difftime(endTime, startTime))
