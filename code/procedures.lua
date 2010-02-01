function s2l_cons(obj1, obj2)
    return {car = obj1; cdr = obj2}
end

function s2l_car(pair)
    return pair.car
end

function s2l_cdr(pair)
    return pair.cdr
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

function s2l_arithmeticMultiply(...)
    local result = 1
    for _, v in ipairs(arg) do
        result = result * v
    end
    return result
end

function s2l_pair(obj)
    return type(obj) == "table" and obj.car
end

function s2l_boolean(obj)
    return type(obj) == "boolean"
end

function s2l_null(obj)
    return obj == nil
end

function s2l_number(obj)
    return type(obj) == "number"
end

function s2l_integer(obj)
    return type(obj) == "number" and obj % 1 == 0
end
