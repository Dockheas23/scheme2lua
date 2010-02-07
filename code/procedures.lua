function s2l_cons(obj1, obj2)
    return {car = obj1; cdr = obj2}
end

function s2l_car(pair)
    return pair.car
end

function s2l_cdr(pair)
    return pair.cdr
end

function s2l_list(...)
    local tmp = {}
    local result = {}
    for i, v in ipairs(arg) do
        table.insert(tmp, 1, v)
    end
    for i, v in ipairs(tmp) do
        result = {car = v; cdr = result}
    end
    return result
end

function s2l_length(list)
    local result = 0
    local l = list
    while not s2l_null(l) do
        l = l.cdr
        result = result + 1
    end
    return result
end

function s2l_filter(proc, list)
    if s2l_null(list) then
        return {}
    elseif proc(list.car) then
        return s2l_cons(list.car, s2l_filter(proc, list.cdr))
    else
        return s2l_filter(proc, list.cdr)
    end
end

function s2l_display(obj)
    if type(obj) == "table" then
        local list = obj
        io.write("(")
        while list.car ~= nil do
            s2l_display(list.car)
            if type(list.cdr) ~= "table" then
                io.write(" . ")
                s2l_display(list.cdr)
                list.cdr = {}
            end
            list = list.cdr
            if list.car ~= nil then
                io.write(" ")
            end
        end
        io.write(")")
    elseif type(obj) == "boolean" then
        if obj then
            io.write("#t")
        else
            io.write("#f")
	end
    else
        io.write(tostring(obj))
    end
end

function s2l_newline()
    io.write("\n")
end

function s2l_arithmeticPlus(...)
    local result = 0
    for _, v in ipairs(arg) do
        result = result + v
    end
    return result
end

-- FIXME
function s2l_arithmeticMinus(a, b)
    return a - b
end

function s2l_arithmeticMultiply(...)
    local result = 1
    for _, v in ipairs(arg) do
        result = result * v
    end
    return result
end

-- FIXME
function s2l_arithmeticDivide(a, b)
    return a / b
end

function s2l_lessThan(n1, n2)
    return n1 < n2
end

function s2l_lessThanOrEqual(n1, n2)
    return n1 <= n2
end

function s2l_equals(n1, n2)
    return n1 == n2
end

function s2l_greaterThan(n1, n2)
    return n1 > n2
end

function s2l_greaterThanOrEqual(n1, n2)
    return n1 >= n2
end

function s2l_and(...)
    local result = true
    for index, item in ipairs(arg) do
        if item == false then
            return item
        else
            result = item
        end
    end
    return result
end

function s2l_or(...)
    for index, item in ipairs(arg) do
        if item then
            return item
        end
    end
    return false
end

function s2l_not(obj)
    return not obj
end

function s2l_pair(obj)
    return type(obj) == "table" and obj.car ~= nil
end

function s2l_boolean(obj)
    return type(obj) == "boolean"
end

function s2l_null(obj)
    return type(obj) == "table" and obj.car == nil
end

function s2l_number(obj)
    return type(obj) == "number"
end

function s2l_integer(obj)
    return type(obj) == "number" and obj % 1 == 0
end
