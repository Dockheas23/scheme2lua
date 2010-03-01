scmData = {
    scmType = "Data";
    create = function (self, o)
        local result = o or {}
        setmetatable(result, self)
        self.__index = self
        self.__tostring = self.valueAsString or scmData.valueAsString
        return result
    end;
    new = function (self, item)
        return self:create{value = item}
    end;
    selfAsString = function (self)
        local funcName = "scm" .. self.scmType .. ":new"
        return funcName .. "("..tostring(self.value)..")"
    end;
    valueAsString = function (self)
        return tostring(self.value)
    end;
}

scmArglist = scmData:create{
    scmType = "Arglist";
    currentIndex = 1;
    numElements = 0;
    value = {};
    add = function (self, item)
        self.numElements = self.numElements + 1
        self.value[self.numElements] = item
    end;
    hasNext = function (self)
        return self.currentIndex > self.numElements
    end;
    nextArg = function (self)
        local result = self.value[self.currentIndex]
        self.currentIndex = self.currentIndex + 1
        return result
    end;
    itemsAsString = function (self)
        local result = ""
        for _, item in ipairs(self.value) do
            result = result .. item:selfAsString() .. ", "
        end
        if result ~= "" then
            result = string.sub(result, 1, -3)
        end
        return result
    end;
    selfAsString = function (self)
        if self.numElements == 0 then
            return ""
        end
        return "scmArglist:new{\n" .. self:itemsAsString() .. "}"
    end;
    fromTable = function (table)
        local result = scmArglist:new()
        for _, value in ipairs(table) do
            result:add(value)
        end
        return result
    end;
}

scmProcedure = scmData:create{
    scmType = "Procedure";
    selfAsString = function (self)
        return tostring(self.value);
    end;
}

scmSymbol = scmData:create{
    scmType = "Symbol";
    selfAsString = function (self)
        return self:valueAsString();
    end;
}

scmBoolean = scmData:create{
    scmType = "Boolean";
    valueAsString = function (self)
        return "#" .. (self.value and "t" or "f")
    end;
}

scmCharacter = scmData:create{
    scmType = "Character";
    selfAsString = function (self)
        return "scmCharacter:new(\"" .. self.value .. "\")"
    end;
}

scmString = scmData:create{
    scmType = "String";
    selfAsString = function (self)
        return "scmString:new(\"" .. self.value .. "\")"
    end;
}

scmNumber = scmData:create{
    scmType = "Number";
}

scmList = scmData:create{
    scmType = "List";
    fromTable = function (table)
        return scmList.fromTableIndex(table, 1)
    end;
    fromTableIndex = function (table, currentIndex)
        if table[currentIndex] == nil then
            return scmList:new()
        elseif tostring(table[currentIndex]) == "." then
            return table[currentIndex + 1]
        else
            return scmList:new{
                car = table[currentIndex];
                cdr = scmList.fromTableIndex(table, currentIndex + 1)
            }
        end
    end;
    fromArglist = function (args)
        return scmList.fromTableIndex(args.value, args.currentIndex)
    end;
    itemsAsString = function (self)
        if self.value == nil then
            return ""
        end
        local car = self.value.car
        local cdr = self.value.cdr
        if cdr.scmType ~= "List" then
            return tostring(car) .. " . " .. tostring(cdr)
        elseif cdr.value == nil then
            return tostring(car)
        else
            return tostring(car) .. " " .. cdr:itemsAsString()
        end
    end;
    selfAsString = function (self)
        if self.value == nil then
            return "scmList:new()"
        end
        return "scmList:new{\ncar = " .. self.value.car:selfAsString()
        .. ";\ncdr = " .. self.value.cdr:selfAsString() .. "}"
    end;
    valueAsString = function (self)
        return "(" .. self:itemsAsString() .. ")"
    end;
}

scmVector = scmData:create{
    scmType = "Vector";
    itemsAsString = function (self)
        local result = ""
        for _, v in ipairs(self.value) do
            result = result .. tostring(v) .. " "
        end
        if result ~= "" then
            result = string.sub(result, 1, -2)
        end
        return result
    end;
    valueAsString = function (self)
        return "#(" .. self:itemsAsString() .. ")"
    end;
}

scmBytevector = scmVector:create{
    scmType = "Bytevector";
    valueAsString = function (self)
        return "#vu8(" .. self:itemsAsString() .. ")"
    end;
}
