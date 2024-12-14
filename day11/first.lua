local startTime = os.time()

local fileHandle = assert(io.open("input", "r"))

local data = {}

local fileData = fileHandle:read("a")
for m in string.gmatch(fileData, "%d+") do
    table.insert(data, tonumber(m))
end

local total = 0

-- implementation goes here

local newData = {}

for _ = 1, 25 do
    newData = {}
    for _, v in ipairs(data) do
        if v == 0 then
            table.insert(newData, 1)
        elseif string.len(tostring(v)) % 2 == 0 then
            local s = tostring(v)
            local l = string.len(s)
            table.insert(newData, tonumber(s:sub(0, l / 2)))
            table.insert(newData, tonumber(s:sub((l / 2) + 1)))
        else
            table.insert(newData, v * 2024)
        end
    end
    -- print(table.concat(newData, ";"))
data = newData
end

-- end of implementation

print("Answer:", #newData)

local endTime = os.time()
print("Time spend (seconds):", os.difftime(endTime, startTime))
