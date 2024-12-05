local listFile = assert(io.open("input", "r"))

local reportList = {}

for line in listFile:lines() do
    local report = {}
    for m in string.gmatch(line, "%d+") do
        table.insert(report, m)
    end
    table.insert(reportList, report)
end

local safeCount = 0

for _, r in ipairs(reportList) do
    local firstDiff = r[2] - r[1]
    safeCount = safeCount + 1
    for i=2,#r do
        local diff = r[i] - r[i - 1]
        if (firstDiff * diff <= 0) or diff > 3 or diff < -3 then
            safeCount = safeCount - 1
            break
        end
    end
end

print(safeCount)
