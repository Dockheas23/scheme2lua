scmArgs = {}
scmArgs.mt = {
    __tostring = function (a)
        local result = ""
        for _, v in ipairs(a) do
            result = result .. v .. ", "
        end
        if result ~= "" then
            result = string.sub(result, 1, -3)
        end
        return result
    end;
}

function scmArgs.new()
    local result = {}
    setmetatable(result, scmBoolean.mt)
    return result
end


scmBoolean = {}
scmBoolean.mt = {
    __eq = function (b1, b2) return b1.value == b2.value end;
    __tostring = function (b) return "#" .. (b.value and "t" or "f") end;
}

function scmBoolean.new(b)
    local result = {scmType = "boolean"; value = b}
    setmetatable(result, scmBoolean.mt)
    return result
end

scmCharacter = {}
scmCharacter.mt = {
    __eq = function (c1, c2) return c1.value == c2.value end;
    __tostring = function (s) return c.value end;
}

function scmCharacter.new(c)
    local result = {scmType = "character"; value = c}
    setmetatable(result, scmCharacter.mt)
    return result
end

scmString = {}
scmString.mt = {
    __eq = function (s1, s2) return s1.value == s2.value end;
    __tostring = function (s) return "\"" .. s.value .. "\"" end;
}

function scmString.new(s)
    local result = {scmType = "string"; value = s}
    setmetatable(result, scmString.mt)
    return result
end

scmNumber = {}
scmNumber.mt = {
    __eq = function (n1, n2) return n1.value == n2.value end;
    __tostring = function (n) return tostring(n.value) end;
}

function scmNumber.new(n)
    local result = {scmType = "number"; value = n}
    setmetatable(result, scmNumber.mt)
    return result
end

scmList = {}
scmList.mt = {
    __tostring = function (l)
        local result = "("
        for _, v in ipairs(l) do
            result = result .. tostring(v) .. " "
        end
        return string.sub(result, 1, -2) .. ")"
    end;
}

function scmList.new(l)
    local result = l
    result.scmType = "list"
    setmetatable(result, scmList.mt)
    return result
end

scmVector = {}
scmVector.mt = {
    __tostring = function (l)
        local result = "#("
        for _, v in ipairs(l) do
            result = result .. tostring(v) .. " "
        end
        return string.sub(result, 1, -2) .. ")"
    end;
}

function scmVector.new(l)
    local result = l
    result.scmType = "vector"
    setmetatable(result, scmVector.mt)
    return result
end

scmBytevector = {}
scmBytevector.mt = {
    __tostring = function (l)
        local result = "#vu8("
        for _, v in ipairs(l) do
            result = result .. tostring(v) .. " "
        end
        return string.sub(result, 1, -2) .. ")"
    end;
}

function scmBytevector.new(l)
    local result = l
    result.scmType = "bytevector"
    setmetatable(result, scmBytevector.mt)
    return result
end
