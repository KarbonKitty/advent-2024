local function listDifference(leftList, rightList)
    table.sort(leftList)
    table.sort(rightList)

    local diff = 0

    for i, l in ipairs(leftList) do
        diff = diff + math.abs(l - rightList[i])
    end

    print(diff)
end

local function listSimilarity(leftList, rightList)
    local rightHash = {}
    for _, n in ipairs(rightList) do
        rightHash[n] = (rightHash[n] or 0) + 1
    end

    local similarity = 0

    for _, n in ipairs(leftList) do
        similarity = similarity + (n * (rightHash[n] or 0))
    end

    print(similarity)
end

local listFile = assert(io.open("input", "r"))

local leftList = {}
local rightList = {}

for line in listFile:lines() do
    local left, right = string.match(line, "(%d+)%s+(%d+)")
    table.insert(leftList, left)
    table.insert(rightList, right)
end

-- listDifference(leftList, rightList)
listSimilarity(leftList, rightList)
