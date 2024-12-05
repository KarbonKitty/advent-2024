local listFile = assert(io.open("input", "r"))

local reportList = {}

for line in listFile:lines() do
    local report = {}
    for m in string.gmatch(line, "%d+") do
        table.insert(report, m)
    end
    reportList[report] = 1
end

local safeCount = 0

local function isSafe(report)
    local i = 2
    while i <= #report do
        local firstDiff = report[2] - report[1]
        local diff = report[i] - report[i - 1]
        if (firstDiff * diff <= 0) or diff > 3 or diff < -3 then
            return i
        end
        i = i + 1
    end
    return -1
end

local function copyReport(report)
    local newReport = {}
    for i, v in ipairs(report) do
        newReport[i] = v
    end
    return newReport
end

for r, dampeners in pairs(reportList) do
    local unsafeElement = isSafe(r)
    if (unsafeElement == -1) then
        safeCount = safeCount + 1
    else
        for i=1,#r do
            local unsafeReport = copyReport(r)
            table.remove(unsafeReport, i)
            if (isSafe(unsafeReport) == -1) then
                safeCount =safeCount + 1
                break
            end
        end
    end
end

print(safeCount)
