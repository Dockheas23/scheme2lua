module(..., package.seeall)

require("parser")
require("scanner")

--
-- A table of the supported Scheme syntaxes
--
syntax = {
    ["case-lambda"] = nil;

    ["cond"] = function ()
        local result = "(function () "
            local token = scanner.peekToken()
            local first = true
            while token ~= ")" do
                scanner.nextToken()
                local test = parser.translate(scanner.nextToken())
                if first then
                    result = result .. "if " .. test .. " then "
                    first = false
                elseif test == "else" then
                    result = result .. "else "
                else
                    result = result .. "elseif " .. test .. " then "
                end
                local expr = parser.translate(scanner.nextToken())
                if expr == "=>" then
                    local func = parser.translate(scanner.nextToken())
                    result = result .. "return " .. func .. "(" .. test .. ") "
                elseif expr == ")" then
                    result = result .. "return " .. test .. " "
                else
                    while expr ~= ")" do
                        if scanner.peekToken() == ")" then
                            result = result .. "return "
                        end
                        result = result .. expr .. "\n"
                        expr = parser.translate(scanner.nextToken())
                    end
                end
                token = scanner.peekToken()
            end
        return result .. "end end)()"
    end;

    ["define"] = function ()
        -- TODO implement other forms of define
        local assignee = parser.translate(scanner.nextToken())
        local object = parser.translate(scanner.nextToken())
        return assignee .. " = " .. object
    end;

    ["lambda"] = function ()
        -- TODO fix dotted pair and single variable parameters
        local list = parser.readDatum()
        local result = "(function ("
            while type(list) == "table" and list.car ~= nil do
                result = result .. tostring(list.car) .. ", "
                list = list.cdr
            end
            result = string.sub(result, 1, -3) .. ")\n"
        .. "return " .. parser.translate(scanner.nextToken()) .. "\n"
        .. "end)"
        return result
    end;

    ["quote"] = function ()
        return parser.datumAsString(parser.readDatum())
    end;

    ["and"] = function ()
        local token = scanner.peekToken()
        local result = "(function ()\nlocal result = true\n"
        while token ~= ")" do
            local test = parser.translate(scanner.nextToken())
            result = result .. "if " .. tostring(test)
                            .. " == false then return false "
            result = result .. "else result = " .. tostring(test) .. " end\n"
            token = scanner.peekToken()
        end
        return result .. "return result end)()"
    end;

    ["or"] = function ()
        local token = scanner.peekToken()
        local result = "(function () "
        while token ~= ")" do
            local test = parser.translate(scanner.nextToken())
            result = result .. "if " .. tostring(test) 
                            .. " then return " .. tostring(test) .. " end\n"
            token = scanner.peekToken()
        end
        return result .. "return false end)()"
    end;

}

--
-- A table of the supported Scheme procedures
--
procedures = {
    ["cond"] = "s2l_cond";
    ["lambda"] = "s2l_lambda";
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
    ["eqv?"] = "s2l_equals";   -- Temporarily

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
}
