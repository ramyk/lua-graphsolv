List = {}

function List:new ()
    local list = { first = 0, last = -1 }
    setmetatable(list, self)
    self.__index = self
    return list
end

function List:pushright (item)
    local last = self.last + 1
    self.last = last
    self[last] = item
end

function List:pushleft (item)
    local first = self.first - 1
    self.first = first
    self[first] = item
end

function List:popright ()
    local last = self.last
    if last < self.first then return nil end
    local item = self[last]
    self[last] = nil
    self.last = last - 1
    return item
end

function List:popleft ()
    local first = self.first
    if first > self.last then return nil end
    local item = self[first]
    self[first] = nil
    self.first = first + 1
    return item
end

return List
