module(..., package.seeall)

require("dataTypes")
require("forms")
require("scanner")

local applyFunction, gatherArguments, getArguments, readCompound

--
-- Return an iterator over the arguments in a Scheme list syntactic form
--
getArguments = function ()
    return function ()
        local token, value = scanner.peekToken()
        if token == ")" or token == "]" then
            return nil
        end
        return scanner.nextToken()
    end
end

--
-- Return the set of Scheme function arguments from the scanner as an
-- scmArglist
--
gatherArguments = function (funcName)
    if forms.specialArgs[funcName] then
        return forms.specialArgs[funcName]()
    else
        local result = scmArglist:new()
        for arg, argValue in getArguments() do
            result:add(parse(arg, argValue))
        end
        return result
    end
end

--
-- Apply the Scheme function 'func'
--
applyFunction = function (func)
    local f = tostring(func)
    if forms.specialSyntax[f] then
        return forms.specialSyntax[f]()
    end
    return (forms.procedures[f] or f)
    .. "(" .. gatherArguments(f):selfAsString() .. ")"
end

--
-- Read and return a single scheme datum from the scanner
--
readDatum = function ()
    local token, value = scanner.peekToken()
    if token == "(" or token == "[" then
        scanner.nextToken()   -- Remove initial bracket
        local list = readList()
        scanner.nextToken()   -- Remove ending bracket
        return list
    elseif token == "#(" or token == "#vu8(" then
        return readVector()
    end
    scanner.nextToken()
    return parse(token, value)
end

--
-- Read and return a scheme list from the scanner (not including brackets)
--
readList = function ()
    local token = scanner.peekToken()
    if token == ")" or token == "]" then
        return scmList:new()
    elseif token == "." then
        scanner.nextToken()
        return readDatum()
    else
        return scmList:new{car = readDatum(); cdr = readList()}
    end
end

--
-- Read and return a scheme vector or bytevector from the scanner (including
-- brackets)
--
readVector = function ()
    local token = scanner.nextToken()
    local objectType = scmVector
    local value = {}
    if token == "#vu8(" then
        objectType = scmBytevector
    end
    token = scanner.peekToken()
    while token ~= ")" do
        table.insert(scmValue, readDatum())
        token = scanner.peekToken()
    end
    scanner.nextToken()
    return objectType:new(value)
end

--
-- Evaluate the Scheme token 'token', with value 'value', and return an scmData
-- encapsulating the appropriate Lua translation
--
function parse(token, value)
    if token == "EOF" then
        return nil
    end

    if token == "Boolean" then
        return scmBoolean:new(value)

    elseif token == "Character" then
        return scmCharacter:new(value)

    elseif token == "String" then
        return scmString:new(value)

    elseif token == "Number" then
        return scmNumber:new(value)

    elseif token == "Symbol" then
        return scmSymbol:new(value)

    elseif token == "(" or token == "[" then
        local procedureValue = applyFunction(parse(scanner.nextToken()))
        scanner.nextToken()
        return scmProcedure:new(procedureValue)

    elseif token == "'" then
        return readDatum()

    else
        return scmData:new(token)
    end
end
