Heap = {}

local function defaultcomp (a,b)
    return a < b
end

function Heap:new (compare)
    local list = {
        len = 0,
        items = {},
        compare = compare or defaultcomp,
    }
    setmetatable(list, self)
    self.__index = self
    return list
end

function Heap:insert (item)
    local i = 0
    repeat
        i = i + 1
    until i > self.len or self.compare(item, self.items[i])
    self.len = self.len + 1
    table.insert(self.items, i, item)
end

function Heap:pop ()
    if self.len <= 0 then return nil end
    self.len = self.len - 1
    return table.remove(self.items, 1)
end

return Heap
