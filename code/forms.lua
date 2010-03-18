module(..., package.seeall)

require("parser")
require("scanner")

--
-- A utility function that returns the string representation of a sequence of
-- scheme expressions (or "body"s) from the scanner, returning the last one.
-- This is a common syntax for lambda, case-lambda, cond, let and others
--
local function bodyList()
    local result = ""
    local token = scanner.peekToken()
    while token ~= ")" do
        local expr = parser.parse(scanner.nextToken())
        if scanner.peekToken() == ")" then
            result = result .. "return "
        end
        result = result .. expr:selfAsString() .. "\n"
        token = scanner.peekToken()
    end
    return result
end;

--
-- A table of supported special syntaxes. Each is a function that returns the
-- final output string for that syntax.
--
specialSyntax = {
    ["cond"] = function ()
        local result = "(function ()\n"
            local token = scanner.peekToken()
            local first = true
            while token ~= ")" do
                scanner.nextToken()  -- Remove initial bracket of clause
                local test = parser.parse(scanner.nextToken())
                if first then
                    result = result .. "if "
                    .. test:selfAsString() .. ".value then\n"
                    first = false
                elseif tostring(test) == "else" then
                    result = result .. "else\n"
                else
                    result = result .. "elseif "
                    .. test:selfAsString() .. ".value then\n"
                end
                local expr = scanner.peekToken()
                if expr == "=>" then
                    scanner.nextToken()
                    local func = parser.parse(scanner.nextToken())
                    result = result .. "return " .. func:selfAsString() ..
                    "(" .. test:selfAsString() .. ")\n"
                elseif expr == ")" then
                    scanner.nextToken()
                    result = result .. "return " .. test:selfAsString() .. "\n"
                else
                    result = result .. bodyList()
                    scanner.nextToken()
                end
                token = scanner.peekToken()
            end
            return result .. "end end)()\n"
        end;

    ["define"] = function ()
        -- TODO implement other forms of define
        local assignee = parser.parse(scanner.nextToken())
        local object = parser.parse(scanner.nextToken())
        return assignee:selfAsString() .. " = " .. object:selfAsString()
    end;

    ["if"] = function ()
        local result = "(function ()\nif "
            .. parser.parse(scanner.nextToken()):selfAsString()
            .. ".value then\nreturn"
            .. parser.parse(scanner.nextToken()):selfAsString() .. "\n"
        if scanner.peekToken() ~= ")" then
            result = result .. "else\nreturn"
            .. parser.parse(scanner.nextToken()):selfAsString() .. "\n"
        end
        return result .. "end end)()\n"
    end;

    ["lambda"] = function ()
        local paramList = {}
        local vararg = false
        local params = parser.readDatum()
        if params.scmType == "List" then
            while params.value ~= nil do
                table.insert(paramList, scmSymbol:new(params.value.car))
                if params.value.cdr.scmType ~= "List" then
                    vararg = params.value.cdr
                    break
                end
                params = params.value.cdr
            end
        else
            vararg = params
        end
        local result = "(function ("
            .. scmArglist.fromTable(paramList):selfAsString()
            .. (vararg and "..." or "") .. ")\n"
            if vararg ~= false then
                result = result .. "local " .. tostring(vararg)
                .. " = scmList.fromTable{...}\n"
            end
            result = result .. bodyList() .. "end)"
        return result
    end;

    ["let"] = function ()
        local funcName = nil
        if scanner.peekToken() == "Symbol" then
            funcName = tostring(parser.parse(scanner.nextToken()))
        end
        scanner.nextToken() -- Opening '(' of var list
        local varNames = {}
        local varValues = {}
        local token = scanner.peekToken()
        while token ~= ")" do
            scanner.nextToken() -- Opening '(' of var definition
            table.insert(varNames, parser.parse(scanner.nextToken()))
            table.insert(varValues, parser.parse(scanner.nextToken()))
            scanner.nextToken() -- Closing ')' of var definition
            token = scanner.peekToken()
        end
        scanner.nextToken() -- Closing ')' of var list
        local funcDef = "(function "
            .. "(" .. scmArglist.fromTable(varNames):selfAsString() .. ")\n"
            .. bodyList() .. "end)"
        local args = scmArglist.fromTable(varValues):selfAsString()
        if funcName then
            return "(function ()\n" .. funcName .. " = " .. funcDef
                .. "\nreturn " .. funcName .. "(" .. args .. ") end)()\n"
        else
            return funcDef .. "(" .. args .. ")\n"
        end
    end;
}

--
-- A table for scheme functions that need all of their arguments wrapped in
-- functions. This prevents the arguments from being fully evaluated and is
-- useful for short-circuit operations
--
wrappedArgs = {
    ["and"] = true;
    ["or"] = true;
}

--
-- A table for scheme functions that need their arguments collected in a
-- non-standard way. Each is a function that returns the argument list as a
-- string.
--
specialArgs = {
    ["quote"] = function ()
        return parser.readDatum():selfAsString()
    end;
}

--
-- A table of the supported Scheme procedures
--
procedures = {
    ["cond"] = "s2l_cond";
    ["quote"] = "s2l_quote";

    ["cons"] = "s2l_cons";
    ["car"] = "s2l_car";
    ["cdr"] = "s2l_cdr";
    ["list"] = "s2l_list";
    ["length"] = "s2l_length";
    ["filter"] = "s2l_filter";

    -- Useful output routines
    ["display"] = "s2l_display";
    ["newline"] = "s2l_newline";

    -- Arithmetic operators
    ["+"] = "s2l_arithmeticPlus";
    ["-"] = "s2l_arithmeticMinus";
    ["*"] = "s2l_arithmeticMultiply";
    ["/"] = "s2l_arithmeticDivide";

    -- Relational operators
    ["<"] = "s2l_lessThan";
    ["<="] = "s2l_lessThanOrEqual";
    ["="] = "s2l_equals";
    [">"] = "s2l_greaterThan";
    [">="] = "s2l_greaterThanOrEqual";
    ["eqv?"] = "s2l_equals";   -- FIXME

    -- Boolean operators
    ["and"] = "s2l_and";
    ["or"] = "s2l_or";
    ["not"] = "s2l_not";

    -- Predicates
    ["pair?"] = "s2l_pair";
    ["boolean?"] = "s2l_boolean";
    ["null?"] = "s2l_null";
    ["number?"] = "s2l_number";
    ["integer?"] = "s2l_integer";

    -- Exit
    ["exit"] = "s2l_exit";
    ["quit"] = "s2l_exit";
}
