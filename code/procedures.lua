--
-- SCHEME TO LUA TRANSLATOR
-- Preamble File 2
-- This file contains the lua implementation of the scheme functions
--

--
-- Utility function to apply a function to its arguments
--
function apply(func, ...)
    return func(scmArglist.fromTable{...})
end


--
-- BEGIN SCHEME FUNCTIONS
--

function s2l_quote(args)
    return args:nextArg()
end

function s2l_cons(args)
    return scmList:new{car = args:nextArg(); cdr = args:nextArg()}
end

function s2l_car(args)
    return args:nextArg().value.car
end

function s2l_cdr(args)
    return args:nextArg().value.cdr
end

function s2l_list(args)
    return scmList:fromArglist(args)
end

function s2l_length(args)
    return scmNumber:new(0) -- FIXME
end

function s2l_filter(args)
    local proc = args:nextArg()
    local list = args:nextArg()
    if apply(s2l_null, list) then
        return scmList:new()
    elseif proc(apply(s2l_car, list)) then
        return apply(s2l_cons,
        apply(s2l_car, list),
        apply(s2l_filter, proc, apply(s2l_cdr, list)))
    else
        return apply(s2l_filter, proc, apply(s2l_cdr, list))
    end
end

function s2l_display(args)
    io.write(tostring(args:nextArg()))
end

function s2l_newline()
    io.write("\n")
end

function s2l_arithmeticPlus(args)
    local result = 0
    while args:hasNext() do
	local item = args:nextArg()
        result = result + 1 -- item.value
    end
    return scmNumber:new(result)
end

-- FIXME
function s2l_arithmeticMinus(args)
    return scmNumber:new(args:nextArg() - args:nextArg())
end

function s2l_arithmeticMultiply(args)
    local result = 1
    while args:hasNext() do
        result = result * args:nextArg().value
    end
    return scmNumber:new(result)
end

-- FIXME
function s2l_arithmeticDivide(args)
    return scmNumber:new(args:nextArg().value / args:nextArg().value)
end

function s2l_lessThan(args)
    return scmBoolean:new(args:nextArg().value < args:nextArg().value)
end

function s2l_lessThanOrEqual(args)
    return scmBoolean:new(args:nextArg().value <= args:nextArg().value)
end

function s2l_equals(args)
    return scmBoolean:new(args:nextArg().value == args:nextArg().value)
end

function s2l_greaterThan(args)
    return scmBoolean:new(args:nextArg().value > args:nextArg().value)
end

function s2l_greaterThanOrEqual(args)
    return scmBoolean:new(args:nextArg().value >= args:nextArg().value)
end

function s2l_and(args)
    local result = scmBoolean:new(true)
    while args:hasNext() do
	local item = args:nextArg()
        if item.value == false then
            return scmBoolean:new(false)
        else
            result = item
        end
    end
    return result
end

function s2l_or(args)
    while args:hasNext() do
	local item = args:nextArg()
        if item.value then
            return item
        end
    end
    return scmBoolean:new(false)
end

function s2l_not(args)
    if args:nextArg().value == false then
        return scmBoolean:new(true)
    end
    return scmBoolean:new(false)
end

function s2l_pair(args)
    local obj = args:nextArg()
    return scmBoolean:new(obj.scmType == "List" and obj.value ~= nil)
end

function s2l_boolean(args)
    local obj = args:nextArg()
    return scmBoolean:new(obj.scmType == "Boolean")
end

function s2l_null(args)
    local obj = args:nextArg()
    return scmBoolean:new(obj.scmType == "List" and obj.value == nil)
end

function s2l_number(args)
    local obj = args:nextArg()
    return scmBoolean:new(obj.scmType == "Number")
end

function s2l_integer(args)
    local obj = args:nextArg()
    return scmBoolean:new(obj.scmType == "Number" and obj.value % 1 == 0)
end

--
-- END SCHEME FUNCTIONS
--
