local startTime = os.time()

local fileHandle = assert(io.open("input", "r"))

local data = {}

local fileData = fileHandle:read("a")
for m in string.gmatch(fileData, "%d+") do
    table.insert(data, tonumber(m))
end

local total = 0

-- implementation goes here

local memory = {}
local limit = 75

local function stoneStep(stoneValue, currentStep)
    local stepsLeft = limit - currentStep

    if memory[stoneValue] then
        if memory[stoneValue][stepsLeft] then
            return memory[stoneValue][stepsLeft]
        end
    else
        memory[stoneValue] = {}
    end

    if stepsLeft == 0 then
        memory[stoneValue][stepsLeft] = 1
        return 1
    end

    local score = 0
    if stoneValue == 0 then
        score = stoneStep(1, currentStep + 1)
    elseif string.len(tostring(stoneValue)) % 2 == 0 then
        local s = tostring(stoneValue)
        local l = string.len(s)
        local firstHalf = tonumber(s:sub(0, l / 2))
        local secondHalf = tonumber(s:sub((l / 2) + 1))
        score = stoneStep(firstHalf, currentStep + 1) + stoneStep(secondHalf, currentStep + 1)
    else
        score = stoneStep(stoneValue * 2024, currentStep + 1)
    end

    memory[stoneValue][stepsLeft] = score
    return score
end

for _, v in ipairs(data) do
    total = total + stoneStep(v, 0)
end

-- end of implementation

print("Answer:", total)

local endTime = os.time()
print("Time spend (seconds):", os.difftime(endTime, startTime))
