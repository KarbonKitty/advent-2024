local wordSearchFile = assert(io.open("input", "r"))

local wordSearch = {}

for line in wordSearchFile:lines() do
    local wordSearchLine = {}
    for m in string.gmatch(line, ".") do
        table.insert(wordSearchLine, m)
    end
    table.insert(wordSearch, wordSearchLine)
end

local function tryRetrieveLetter(r, c, x, y)
    if (r + y) < 1 or (r + y) > #wordSearch then
        return nil, false
    end
    if (c + x) < 1 or (c + x) > #(wordSearch[r + y]) then
        return nil, false
    end
    return wordSearch[r + y][c + x], true
end

local function checkXmas(r, c)
    local first = false
    local second = false
    -- first diagonal
    local one, worthCheckingOne = tryRetrieveLetter(r, c, -1, -1)
    local two, worthCheckingTwo = tryRetrieveLetter(r, c, 1, 1)

    if worthCheckingOne and worthCheckingTwo then
        if (one == "M" and two == "S") or (one == "S" and two == "M") then
            first = true
        end
    end

    -- second diagonal
    local one, worthCheckingOne = tryRetrieveLetter(r, c, 1, -1)
    local two, worthCheckingTwo = tryRetrieveLetter(r, c, -1, 1)

    if worthCheckingOne and worthCheckingTwo then
        if (one == "M" and two == "S") or (one == "S" and two == "M") then
            second = true
        end
    end

    return first and second
end

local count = 0

for r, line in ipairs(wordSearch) do
    for c, letter in ipairs(line) do
        if letter == "A" then
            local isXmas = checkXmas(r, c)
            if isXmas then
                count = count + 1
            end
        end
    end
end

print(count)
