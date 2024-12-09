local wordSearchFile = assert(io.open("input", "r"))

local wordSearch = {}

for line in wordSearchFile:lines() do
    local wordSearchLine = {}
    for m in string.gmatch(line, ".") do
        table.insert(wordSearchLine, m)
    end
    table.insert(wordSearch, wordSearchLine)
end

local directions = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 }, { 1, 1 }, { -1, 1 }, { 1, -1 }, { -1, -1 } }

local function tryRetrieveLetter(r, c, x, y)
    if (r + y) < 1 or (r + y) > #wordSearch then
        return nil, false
    end
    if (c + x) < 1 or (c + x) > #(wordSearch[r + y]) then
        return nil, false
    end
    return wordSearch[r + y][c + x], true
end

local function checkWord(r, c, x, y)
    local isM, worthChecking = tryRetrieveLetter(r, c, x, y)
    if not worthChecking then
        return false;
    end
    if isM ~= "M" then
        return false
    end
    local isA, worthChecking = tryRetrieveLetter(r, c, 2 * x, 2 * y)
    if not worthChecking then
        return false;
    end
    if isA ~= "A" then
        return false
    end
    local isS, worthChecking = tryRetrieveLetter(r, c, 3 * x, 3 * y)
    if not worthChecking then
        return false;
    end
    if isS ~= "S" then
        return false
    end
    return true
end

local count = 0

for r, line in ipairs(wordSearch) do
    for c, letter in ipairs(line) do
        if letter == "X" then
            for _, pair in ipairs(directions) do
                local isXmas = checkWord(r, c, pair[1], pair[2])
                if isXmas then
                    count = count + 1
                end
            end
        end
    end
end

print(count)
