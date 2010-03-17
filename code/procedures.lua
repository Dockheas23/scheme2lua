--
-- SCHEME TO LUA TRANSLATOR
-- Preamble File 2
-- This file contains the lua implementation of the scheme functions
--

--
-- BEGIN SCHEME FUNCTIONS
--

function s2l_quote(obj)
    return obj
end

function s2l_cons(obj1, obj2)
    return scmList:new{car = obj1; cdr = obj2}
end

function s2l_car(pair)
    return pair.value.car
end

function s2l_cdr(pair)
    return pair.value.cdr
end

function s2l_list(...)
    return scmList.fromTable{...}
end

function s2l_length(list)
    local result = 0
    while not s2l_null(list).value do -- FIXME Clean up (metamethods maybe)
        result = result + 1
        list = s2l_cdr(list)
    end
    return scmNumber:new(result)
end

function s2l_filter(proc, list)
    if s2l_null(list).value then -- FIXME Clean up (metamethods maybe)
        return scmList:new()
    elseif proc(s2l_car(list)).value then -- FIXME Clean up (metamethods maybe)
        return s2l_cons(s2l_car(list), s2l_filter(proc, s2l_cdr(list)))
    else
        return s2l_filter(proc, s2l_cdr(list))
    end
end

function s2l_display(obj)
    io.write(tostring(obj))
end

function s2l_newline()
    io.write("\n")
end

function s2l_arithmeticPlus(...)
    local result = 0
    for _, item in ipairs{...} do
        result = result + item.value
    end
    return scmNumber:new(result)
end

-- FIXME
function s2l_arithmeticMinus(a, b)
    return scmNumber:new(a.value - b.value)
end

function s2l_arithmeticMultiply(...)
    local result = 1
    for _, item in ipairs{...} do
        result = result * item.value
    end
    return scmNumber:new(result)
end

-- FIXME
function s2l_arithmeticDivide(a, b)
    return scmNumber:new(a.value / b.value)
end

function s2l_lessThan(n1, n2)
    return scmBoolean:new(n1.value < n2.value)
end

function s2l_lessThanOrEqual(n1, n2)
    return scmBoolean:new(n1.value <= n2.value)
end

function s2l_equals(n1, n2)
    return scmBoolean:new(n1.value == n2.value)
end

function s2l_greaterThan(n1, n2)
    return scmBoolean:new(n1.value > n2.value)
end

function s2l_greaterThanOrEqual(n1, n2)
    return scmBoolean:new(n1.value >= n2.value)
end

-- Short circuit
function s2l_and(...)
    local result = scmBoolean:new(true)
    for _, f in ipairs{...} do
        local item = f()
        if item.value == false then
            return scmBoolean:new(false)
        else
            result = item
        end
    end
    return result
end

-- Short circuit
function s2l_or(...)
    for _, f in ipairs{...} do
        local item = f()
        if item.value then
            return item
        end
    end
    return scmBoolean:new(false)
end

function s2l_not(obj)
    if obj.value == false then
        return scmBoolean:new(true)
    end
    return scmBoolean:new(false)
end

function s2l_pair(obj)
    return scmBoolean:new(obj.scmType == "List" and obj.value ~= nil)
end

function s2l_boolean(obj)
    return scmBoolean:new(obj.scmType == "Boolean")
end

function s2l_null(obj)
    return scmBoolean:new(obj.scmType == "List" and obj.value == nil)
end

function s2l_number(obj)
    return scmBoolean:new(obj.scmType == "Number")
end

function s2l_integer(obj)
    return scmBoolean:new(obj.scmType == "Number" and obj.value % 1 == 0)
end

function s2l_exit()
    return nil
end

--
-- END SCHEME FUNCTIONS
--
