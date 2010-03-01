module(..., package.seeall)

local stripLineComment, stripBlockComment, stripDatumComment
local charCache
local tokenCache

--
-- Return true if 'x' is a whitespace character
--
local function isWhiteSpace(x)
    return string.match(x, "^[%s]$")
end

--
-- Return true if 'x' is a delimiter
-- (For symbols, numbers, characters, booleans and the dotted pair marker)
--
local function isDelimiter(x)
    return isWhiteSpace(x) or x == ""
    or string.match(x, "^[%[%]%(%)\"';]$")
end

--
-- Return true if 'x' is a valid first character for a symbol
-- TODO Escaped Hex and Unicode characters currently not supported
--
local function isInitialSymbolChar(x)
    return string.match(x, "^[%a!&/:<=>~_%^%$%*%?%%]$")
end

--
-- Return true if 'x' is a valid subsequent character for a symbol
-- TODO Escaped Hex and Unicode characters currently not supported
--
local function isSubsequentSymbolChar(x)
    return isInitialSymbolChar(x) or string.match(x, "^[%d%.%+%-@]$")
end

--
-- Set up the scanner
--
function init()
    charCache = nil
    tokenCache = nil
end

--
-- Remove and return the next input character
--
local function nextChar()
    local result
    if charCache then
        result = charCache
        charCache = nil
    elseif not io.read(0) then
        result = ""
    else
        result = io.read(1)
    end
    return result
end

--
-- Return the next input character without removing it
--
local function peekChar()
    if not charCache then
        charCache = nextChar()
    end
    return charCache
end

--
-- Remove and return the next token from the scanner
--
function nextToken()
    local token
    local value = nil
    local c

    if tokenCache then
        token, value = tokenCache[1], tokenCache[2]
        tokenCache = nil
        return token, value
    end

    repeat
        c = nextChar()
        if c == ";" then
            c = stripLineComment()
        elseif c == "#" and peekChar() == "|" then
            c = stripBlockComment()
        elseif c == "#" and peekChar() == ";" then
            c = stripDatumComment()
        end
    until not isWhiteSpace(c) or c == ""

    if c == "" then
        token = "EOF"

    -- Check for peculiar symbols '+' and '-'
    elseif (c == "+" or c == "-") and isDelimiter(peekChar()) then
        token = c

    -- Check for peculiar symbol '...'
    elseif c == "." and peekChar() == "."
        and nextChar() == "." and peekChar == "." then
        nextChar()
        token = "..."

    elseif c == "-" and peekChar() == ">"   -- Another peculiar symbol
        or isInitialSymbolChar(c) then      -- Regular symbol
        local symbolValue = c
        while isSubsequentSymbolChar(peekChar()) do
            c = nextChar()
            symbolValue = symbolValue .. c
        end
        token, value = "Symbol", symbolValue

    elseif c == "#" and string.match(peekChar(), "[TtFf]") then
        token = "Boolean"
        if string.match(nextChar(), "[Tt]") then
            value = true
        else
            value = false
        end

    elseif c == "#" and peekChar() == "\\" then
        --
        -- TODO Named and hex characters currently not supported
        --
        token = "Character"
        nextChar()
        value = nextChar()
        
    elseif c == "\"" then
        --
        -- TODO Escape characters and multiline strings currently not
        -- supported
        --
        local stringValue = ""
        c = nextChar()
        while c ~= "\"" and c ~= "" do
            stringValue = stringValue .. c
            c = nextChar()
        end
        token, value = "String", stringValue

    elseif c == "#" and string.match(peekChar(), "[bodxie]")
        --
        -- TODO Numbers not properly supported yet
        --
        or string.match(c, "[+%-%d]") then
        local numberValue = string.byte(c) - string.byte("0")
        while string.match(peekChar(), "%d") do
            c = nextChar()
            local digit = string.byte(c) - string.byte("0")
            numberValue = 10 * numberValue + digit
        end
        token, value = "Number", numberValue
        
    elseif c == "#" and peekChar() == "(" then
        nextChar()
        token = "#("

    elseif c == "#" and string.match(peekChar(), "[vV]")
        and nextChar() and string.match(peekChar(), "[uU]") then
        nextChar()
        nextChar()
        token = "#vu8("

    else token = c
        --
        -- TODO Checking for invalid tokens currently not supported
        --
    end

    return token, value
end

--
-- Return the next token from the scanner without removing it
--
function peekToken()
    if tokenCache then
        return tokenCache[1], tokenCache[2]
    else
        local token, value = nextToken()
        tokenCache = {token, value}
        return token, value
    end
end

--
-- Remove a line comment from the scanner and return the next character
--
stripLineComment = function ()
    local c
    repeat
        c = nextChar()
    until c == "\n" or c == ""
    return c
end

--
-- Remove a block comment from the scanner and return the next character
--
stripBlockComment = function ()
    local c
    local nestLevel = 1
    nextChar()
    repeat
        c = nextChar()
        if c == "#" and nextChar() == "|" then
            c = nextChar()
            nestLevel = nestLevel + 1
        elseif c == "|" and nextChar() == "#" then
            c = nextChar()
            nestLevel = nestLevel - 1
        end
    until nestLevel == 0 or c == ""
    return c
end

--
-- Remove a block comment from the scanner and return the next character
-- TODO Datum comments not currently supported
--
stripDatumComment = function ()
    return c
end
