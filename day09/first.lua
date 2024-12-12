local startTime = os.time()

local fileData = assert(io.open("input", "r"))

local map = {}

local isFile = true
local fileID = 0
for m in string.gmatch(fileData:read("a"), "%d") do
    if isFile then
        for i = 1, tonumber(m), 1 do
            table.insert(map, fileID)
        end
        fileID = fileID + 1
    else
        for i = 1, tonumber(m), 1 do
            table.insert(map, false)
        end
    end
    isFile = not isFile
end

local newMap = {}
local i = 0
local stop = #map

while i < stop do
    i = i + 1
    local v = map[i]
    if v then
        table.insert(newMap, v)
    else
        local fromEnd = map[stop]
        while not fromEnd do
            stop = stop - 1
            fromEnd = map[stop]
        end
        table.insert(newMap, fromEnd)
        stop = stop - 1
    end
end

local total = 0

for j, v in ipairs(newMap) do
    total = total + ((j - 1) * v)
end

local endTime = os.time()

print(total)
print(os.difftime(endTime, startTime))
