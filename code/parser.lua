module(..., package.seeall)

require("forms")
require("scanner")

--
-- Apply the Scheme function 'func'
--
local function applyFunction(func)
    local funcName = func
    if forms.syntax[func] then
        return forms.syntax[func]()
    elseif forms.procedures[func] then
        funcName = forms.procedures[func]
    end
    return funcName .. "(" .. gatherArguments() .. ")"
end

--
-- Return the set of Scheme function arguments from the scanner as a
-- comma-separated string
--
function gatherArguments()
    local argList = ""
    for arg, argValue in getArguments() do
        argList = argList .. translate(arg, argValue) .. ", "
    end
    if argList ~= "" then
        argList = string.sub(argList, 1, -3)
    end
    return argList
end

--
-- Return an iterator over the arguments in a Scheme list syntactic form
--
function getArguments()
    return function ()
        local token, value = scanner.peekToken()
        if token == ")" or token == "]" then
            return nil
        end
        return scanner.nextToken()
    end
end

--
-- Read and return a single scheme datum from the scanner
-- TODO List is currently the only compound datum supported
-- Vector and Bytevector yet to be implemented
--
function readDatum()
    local token, value = scanner.nextToken()
    local result
    if token == "(" or token == "[" then
        return readList()
    end
    return translate(token, value)
end

function readList()
    local token, value = scanner.peekToken()
    if token == ")" or token == "]" then
        scanner.nextToken()
        return {}
    elseif token == "." then
        scanner.nextToken()
        local lastItem = readDatum()
        scanner.nextToken()
        return lastItem
    else
        return {car = readDatum(); cdr = readList()}
    end
end

--
-- Return a string representation of 'datum'
--
function datumAsString(datum)
    if type(datum) == "table" then
        local result = "{"
        for key, value in pairs(datum) do
            result = result .. "[\"" .. tostring(key) .. "\"] = "
            .. datumAsString(value) .. "; "
        end
        return result .. "}"
    else
        return tostring(datum)
    end
end

--
-- Evaluate the Scheme token 'token', with value 'value', and return the
-- appropriate Lua translation
--
function translate(token, value)
    if token == "EOF" then
        return nil
    end

    if token == "boolean" or token == "number" or token == "symbol" then
        return value

    elseif token == "character" or token == "string" then
        return "\"" .. value .. "\""

    elseif token == "(" or token == "[" then
        local procedureValue = applyFunction(translate(scanner.nextToken()))
        scanner.nextToken()
        return procedureValue

    elseif token == "'" then
        return applyFunction("quote")
    else
        return token
    end
end
