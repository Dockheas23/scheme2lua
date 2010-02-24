module(..., package.seeall)

require("forms")
require("dataTypes")
require("scanner")

local
applyFunction,
gatherArguments,
getArguments,
readDatum,
readCompound

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
-- Return the set of Scheme function arguments from the scanner as a table
--
gatherArguments = function (funcName)
    local args = scmArgs.new()
    if specialSyntax[funcName] then
        return specialSyntax[funcName]()
    end
    for arg, argValue in getArguments() do
        table.insert(args, translate(arg, argValue))
    end
    return tostring(args)
end

--
-- Apply the Scheme function 'func'
--
applyFunction = function (func)
    local funcName = procedures[func] or func
    return (procedures[func] or func) .. "(" .. gatherArguments(func) .. ")"
end

--
-- Read and return a single scheme datum from the scanner
--
readDatum = function ()
    local token, value = scanner.peekToken()
    local result
    if token == "(" or token == "[" or token == "#(" or token == "#vu8(" then
        return readCompound()
    end
    scanner.nextToken()
    return translate(token, value)
end

--
-- Read and return a compound scheme datum from the scanner
--
readCompound = function ()
    local args = scmArgs.new()
    local token, value = scanner.nextToken()
    local dataType = "scmList"
    if token == "#(" then
        dataType = "scmVector"
    elseif token == "#vu8(" then
        dataType = "scmBytevector"
    end
    while token ~= ")" and token ~= "]" do
        table.insert(args, readDatum())
        token, value = scanner.peekToken()
    end
    return dataType .. ".new({" .. tostring(args) .. "})"
end

--
-- Evaluate the Scheme token 'token', with value 'value', and return the
-- appropriate Lua translation
--
function translate(token, value)
    if token == "EOF" then
        return nil
    end

    if token == "symbol" then
        return value

    elseif token == "boolean" then
        return "scmBoolean.new(" .. tostring(value) .. ")"

    elseif token == "character" then
        return "scmCharacter.new(" .. tostring(value) .. ")"

    elseif token == "string" then
        return "scmString.new(" .. tostring(value) .. ")"

    elseif token == "number" then
        return "scmNumber.new(" .. tostring(value) .. ")"

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
