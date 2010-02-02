module(..., package.seeall)

require("parser")
require("scanner")

--
-- A table of the supported Scheme syntaxes
--
syntax = {
    ["case-lambda"] = nil;

    ["cond"] = nil;

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
    end
}

--
-- A table of the supported Scheme procedures
--
procedures = {
    ["cons"] = "s2l_cons";
    ["car"] = "s2l_car";
    ["cdr"] = "s2l_cdr";

    -- Useful output routines
    ["display"] = "s2l_display";
    ["newline"] = "s2l_newline";

    -- Arithmetic operators
    ["+"] = "s2l_arithmeticPlus";
    ["-"] = "s2l_arithmeticMinus";
    ["*"] = "s2l_arithmeticMultiply";
    ["/"] = "s2l_arithmeticDivide";

    -- Relational operators
    ["<"] = nil;
    ["<="] = nil;
    ["="] = nil;
    [">"] = nil;
    [">="] = nil;

    -- Predicates
    ["pair?"] = "s2l_pair";
    ["boolean?"] = "s2l_boolean";
    ["null?"] = "s2l_null";
    ["number?"] = "s2l_number";
    ["integer?"] = "s2l_integer";
}
