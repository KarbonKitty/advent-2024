local startTime = os.time()

local fileHandle = assert(io.open("input", "r"))

local data = {}

for line in fileHandle:lines() do
    local dataLine = {}
    local a = string.match(line, "Register A: (%d+)")
    if a  then
        data.a = tonumber(a)
    end
    local b = string.match(line, "Register B: (%d+)")
    if b then
        data.b = tonumber(b)
    end
    local c = string.match(line, "Register C: (%d+)")
    if c then
        data.c = tonumber(c)
    end
    local p = string.match(line, "Program")
    if p then
        for m in string.gmatch(line, "(%d+)") do
            table.insert(dataLine, tonumber(m))
        end
        data.p = dataLine
    end
end

local total = ""

-- implementation goes here
local pc = 1

local function getCombo(operand)
    if operand <= 3 then
        return operand
    elseif operand == 4 then
        return data.a
    elseif operand == 5 then
        return data.b
    elseif operand == 6 then
        return data.c
    else
        print("error")
        return nil
    end
end

while pc <= #data.p do
    local operation = data.p[pc]
    local operand = data.p[pc + 1]

    if operation == 0 then
        data.a = data.a >> (getCombo(operand))
        pc = pc + 2
    elseif operation == 1 then
        data.b = data.b ~ operand
        pc = pc + 2
    elseif operation == 2 then
        data.b = getCombo(operand) % 8
        pc = pc + 2
    elseif operation == 3 then
        if data.a ~= 0 then
            pc = operand + 1
        else
            pc = pc + 2
        end
    elseif operation == 4 then
        data.b = data.b ~ data.c
        pc = pc + 2
    elseif operation == 5 then
        local output = getCombo(operand) % 8
        total = total .. output .. ","
        pc = pc + 2
    elseif operation == 6 then
        data.b = data.a >> (getCombo(operand))
        pc = pc + 2
    elseif operation == 7 then
        data.c = data.a >> (getCombo(operand))
        pc = pc + 2
    end
end

-- end of implementation

print("Answer:", total)

local endTime = os.time()
print("Time spend (seconds):", os.difftime(endTime, startTime))
