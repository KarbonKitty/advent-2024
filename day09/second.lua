local startTime = os.time()

local fileData = assert(io.open("input", "r"))

local map = {}

local isFile = true
local fileID = 0

for m in string.gmatch(fileData:read("a"), "%d") do
    if isFile then
        table.insert(map, { type = "file", size = tonumber(m), id = fileID })
        fileID = fileID + 1
    else
        table.insert(map, { type = "space", size = tonumber(m) })
    end
    isFile = not isFile
end

local i = 0
while i < #map do
    if map[#map - i].type == "file" then
        local file = map[#map - i]
        local done = false
        for j = 1, #map - i, 1 do
            if map[j].type == "space" and not done then
                local space = map[j]
                if file.size == space.size then
                    map[j] = file
                    map[#map - i] = { type = "space", size = file.size }
                    done = true
                elseif file.size < space.size then
                    table.insert(map, j, file)
                    space.size = space.size - file.size
                    map[#map - i] = { type = "space", size = file.size }
                    done = true
                end
            end
        end
    end
    i = i + 1
end

local total = 0

local block = 0
for j, item in ipairs(map) do
    if item.type == "file" then
        for i = 1, item.size, 1 do
            total = total + (block * item.id)
            block = block + 1
        end
    else
        block = block + item.size
    end
end

local endTime = os.time()

print(total)
print(os.difftime(endTime, startTime))
