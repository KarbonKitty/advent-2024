local startTime = os.time()

local fileHandle = assert(io.open("input", "r"))

local data = {}

for line in fileHandle:lines() do
    local dataLine = {}
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
data.a = 0
data.b = 0
data.c = 0

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

local done = false

-- solution done partially by hand:
    -- set variable tail and size of the counter step at the bottom of the loop
    -- start with high tail and large step
    -- find the interesting ranges
    -- narrow down the ranges reducing tail and counter step
    -- unless we hit the answer
    -- for the input, the values below hit on the correct answer almost immediately

local counter = 0x0000b89eb2f00000
local maxCounter = 0x0000b8a000000000
local programString = table.concat(data.p, "")

while not done do
    data.a = counter
    data.b = 0
    data.c = 0
    pc = 1
    total = ""
    -- if counter % 1024 == 0 then
    --     print(string.format("%016x", counter))
    -- end

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
            total = total .. output
            if programString == total then
                print("Answer: ", counter)
                return
            end
            if (string.len(total) > string.len(programString)) or (counter > maxCounter) then
                print("max achieved")
                done = true
                -- break out of inner loop
                pc = 1 << 31
            end
            pc = pc + 2
        elseif operation == 6 then
            data.b = data.a >> (getCombo(operand))
            pc = pc + 2
        elseif operation == 7 then
            data.c = data.a >> (getCombo(operand))
            pc = pc + 2
        end
    end

    local tail = 1

    if total:sub(tail) == programString:sub(tail) then
        print("total length:", total:len(), "program length: ", programString:len(), "counter: ", string.format("%016x", counter))
        print(total, total:sub(tail))
        print(programString, programString:sub(tail))
        print("counter: ", string.format("%016x", counter))
        io.read()
    end

    counter = counter + 0x1
end

-- end of implementation

print("Answer:", total)

local endTime = os.time()
print("Time spend (seconds):", os.difftime(endTime, startTime))
