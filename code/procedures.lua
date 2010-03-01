function apply(func, ...)
    return func(scmArglist.fromTable{...})
end

--function s2l_cond(...)
    --for _, clause in ipairs(arg) do
        --local test = s2l_car(clause)
        --if test() and test ~= "else" then
            --if s2l_null(s2l_cdr(clause)) then
                --return test
            --elseif clause[2] == "=>" then
                --return clause[3](test)
            --else
                --local result
                --for i, expr in ipairs(clause) do
                    --if i ~= 1 then
                        --result = expr()
                    --end
                --end
                --return result
            --end
        --end
    --end
--end

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

function s2l_length(list)
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

function s2l_arithmeticPlus(...)
    local result = 0
    for _, v in ipairs(arg) do
        result = result + v.value
    end
    return scmNumber:new(result)
end

-- FIXME
function s2l_arithmeticMinus(a, b)
    return scmNumber:new(a.value - b.value)
end

function s2l_arithmeticMultiply(...)
    local result = 1
    for _, v in ipairs(arg) do
        result = result * v.value
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

function s2l_and(...)
    local result = scmBoolean:new(true)
    for _, item in ipairs(arg) do
        if item.value == false then
            return item.value
        else
            result = item
        end
    end
    return result
end

function s2l_or(...)
    for _, item in ipairs(arg) do
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
